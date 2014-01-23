require_relative 'charts'

class InfrastructureCharts < Charts
  attr_reader :mean_count, :mode_count, :median_count, :external_providers

  def initialize
    # TODO run all computation once?
    compute_averages
  end

  def support_piedata
    data = Charts.new.get_piedata 'infrastructures.continent', false

    data.each do |e|
      case e[0].upcase!
        when "EU"
          e[0] = "Europe"
        when "SA"
          e[0] = "South America"
        when "NA"
          e[0] = "North America"
        when "AS"
          e[0] = "Asia"
        when "OC"
          e[0] = "Oceania"
        else
          e[0] = "Africa"
      end
    end

    # missing continents
    data << ['Africa', 0]

    return data
  end

  def infras
    data = Hash.new
    # todo vendors that allow multiple deployments in one country are counted double
    Vendor.where(:infrastructures.exists => true).only(:infrastructures).each do |vendor|
      if !vendor.infrastructures.blank?
        vendor.infrastructures.each do |i|
          if !i.country.empty?
            unless data[i.country].nil?
              data[i.country] += 1
            else
              data[i.country] = 1
            end
          end
        end
      end
    end

    data.to_json
  end

  def external_providers
    @external_providers ||= Vendor.where(:'infrastructures.provider'.exists => true).count
  end

  def top_continents
    continents = %w( EU NA SA AS AF OC )
    data = []

    continents.each do |c|
      count = Vendor.where('infrastructures.continent' => c).count
      public = Vendor.where('hosting.public' => true).count
      data << [ c, (count / public.to_f * 100).round(0) ]
    end

    data.sort! { |x,y| y[1] <=> x[1] }
  end

  def top_countries( amount=5 )
    h = JSON.parse(infras)
    h.keys.sort {|a, b| h[b] <=> h[a]}
  end

  private

  def compute_averages
    # only public offerings
    # TODO what about possibly missing null infras
    infra_count = Vendor.where('hosting.public' => true).collect { |v| v.infrastructures.count }
    # mean
    sum_infras = 0
    infra_count.each { |v| sum_infras += v }
    @mean_count = (sum_infras / infra_count.size.to_f).round(1)
    # median
    infra_count.sort!
    len = infra_count.size
    @median_count = (infra_count[(len - 1) / 2] + infra_count[len / 2]) / 2.0
    # mode
    @mode_count = infra_count.group_by { |n| n }.values.max_by(&:size).first
  end

end