require_relative 'charts'

module Profiles
  class InfrastructureCharts < Charts
    attr_reader :mean_count, :mode_count, :median_count, :variance, :sd, :min, :max

    def initialize
      compute_averages
    end

    def continent_codes
      {
        'AF' => 'Africa',
        'AS' => 'Asia',
        'EU' => 'Europe',
        'NA' => 'North America',
        'OC' => 'Oceania',
        'SA' => 'South America'
      }
    end

    def continent_by_code(code)
      continent_codes[code]
    end

    def support_piedata
      data = Charts.new.get_piedata 'infrastructures.continent', false

      data.each do |e|
        e[0] = @continent_codes[e[0]]
      end

      # missing continents
      data << ['Africa', 0]

      data
    end

    def heatmap
      data = {}
      # TODO: vendors that allow multiple deployments in one country are counted double
      Vendor.where(:infrastructures.exists => true).only(:infrastructures).each do |vendor|
        next if vendor.infrastructures.blank?

        vendor.infrastructures.each do |i|
          next if i.country.empty?

          if !data[i.country].nil?
            data[i.country] += 1
          else
            data[i.country] = 1
          end

        end

      end

      data.to_json
    end

    def external_providers
      @external_providers ||= Vendor.where(:'infrastructures.provider'.exists => true).count
    end

    def top_continents
      data = []

      continent_codes.each_key do |c|
        count = Vendor.where('infrastructures.continent' => c).count
        public = Vendor.where('hosting.public' => true).count
        # TODO: missing public infras
        percentage = (count / public.to_f * 100).round(0)
        data << { name: continent_by_code(c), y: percentage }
      end

      data.sort! { |x, y| y[:y] <=> x[:y] }
      data.to_json
    end

    def top_countries(amount = 5)
      # TODO: hacky
      h = JSON.parse(heatmap)
      top = h.keys.sort { |a, b| h[b] <=> h[a] }
      data = []
      h.each do |e|
        data << { name: e[0], value: e[1] } if top.include? e[0]
      end
      data.sort! { |x, y| y[:value] <=> x[:value] }
      data.first(amount)
    end

    def averages_data
      infra_count = Vendor.where('hosting.public' => true).collect { |v| v.infrastructures.count }
      infra_count.delete_if(&:zero?)
      infra_count.sort!
    end

    private

    def compute_averages
      # only public offerings
      infra_count = Vendor.where('hosting.public' => true).collect { |v| v.infrastructures.count }
      # TODO: data fuzz: remove missing infrastructures
      infra_count.delete_if(&:zero?)
      @mean_count = Charts.mean(infra_count)
      @median_count = Charts.median(infra_count)
      @mode_count = Charts.mode(infra_count)
      @variance = Charts.variance(infra_count)
      @sd = Charts.standard_deviation(infra_count)
      @min = infra_count.min
      @max = infra_count.max
    end
  end
end
