require_relative '../../app/models/vendor/vendor'
require_relative '../../app/models/snapshot'
require_relative '../../app/models/statistics/runtime_trend'
require_relative '../version'
require_relative '../helper/statistics_helper'

# Base class that contains shared attributes and methods for specific chart implementations
module Profiles
  class Charts
    extend StatisticsHelper

    # Standard color array for Highcharts
    COLORS = %w(#2f7ed8 #0d233a #8bbc21 #910000 #1aadce #492970 #f28f43 #77a1e5 #c42525 #a6c96a).freeze

    attr_reader :vendor_count, :extensible_count, :verified_count

    # Returns the total amount of vendors in the database
    def vendor_count
      @vendor_count ||= Vendor.count
    end

    # Returns the total amount of vendors that verified their profile
    def verified_count
      @verified_count ||= Vendor.where(:vendor_verified.exists => true).count
    end

    def extensible_count
      @extensible_count ||= Vendor.where(extensible: true).count
    end

    def get_piedata(type, threshold = 0.05)
      data = []

      distinct_values(type).each do |l|
        count = Vendor.where(type => l).count
        # TODO: if property is not mandatory this will lead to false % distribution, e.g. middleware
        # Wrong chart type because values don't add up to a 100 %
        data << [l, count]
      end

      # capitalize
      data.each { |e| e[0].capitalize! }
      # sort by count ascending
      data.sort! { |x, y| y[1] <=> x[1] }
      # 5 % threshold
      if threshold
        sum = 0
        data.each { |e| sum += e[1] }
        others = ['Others', 0]

        data.delete_if do |e|
          if (e[1].to_f / sum) < threshold
            others[1] += e[1]
            true
          end
        end
        data << others
      end

      data
    end

    # TODO: define no threshold = false or 0? -> tests
    def support_columndata(type, threshold = 0.05)
      data = []

      distinct_values(type).each_with_index do |l, _i|
        count = Vendor.where(type => l).count
        rt = RuntimeVersion.where(name: l).first
        latest = rt['version'] unless rt.blank?

        data << { name: l, y: (count / vendor_count.to_f * 100).to_i, drilldown: {
          name: "#{l.capitalize} Versions",
          categories: distinct_versions(l),
          latest: latest,
          data: distinct_versions_data(l)
        } }
      end

      # capitalize each word
      data.each { |e| e[:name].capitalize! }
      # sort by count descending
      data.sort! { |x, y| y[:y] <=> x[:y] }
      # % threshold
      if threshold
        sum = 0
        data.each { |e| sum += e[:y] }
        others = { name: 'Others', y: 0 }

        data.delete_if do |e|
          if e[:y].to_f < (threshold * 100.0)
            # aggregate those below the threshold TODO + value or only +1 for others?
            others[:y] += e[:y]
            true
          end
        end

        data << others unless others[:y] == 0
      end

      # colors
      data.each_with_index do |l, i|
        l[:color] = COLORS[i % COLORS.length]
        if l[:name] != 'Others'
          l[:drilldown][:color] = COLORS[i % COLORS.length]
        end
      end

      data.to_json
    end

    def language_count(language)
      Vendor.where('runtimes.language' => language).length
    end

    def distinct_versions(language)
      distinct_versions_data(language).collect { |x| x[0] }
    end

    def distinct_versions_data(language)
      # TODO: duplicate languages in profile will cause false results
      vendors = Vendor.where('runtimes.language' => language)
      data = {}

      vendors.each do |vendor|
        vendor['runtimes'].each do |rt|
          next unless rt['language'] == language

          if rt['versions'].blank?
            if data.key? 'Unknown'
              data['Unknown'] += 1
            else
              data['Unknown'] = 1
            end
          else
            rt['versions'].each do |v|
              # TODO: uniform version format, filter empty versions
              v = Version.new(v).unify

              if data.key? v
                data[v] += 1
              else
                data[v] = 1
              end
            end
          end

        end
      end

      # TODO: sort bug 0.11 > 0.2
      data = data.sort { |x, y| x <=> y }
      # TODO: rundungsfehler bug?!
      data.each do |v|
        v[1] = (v[1] / language_count(language).to_f * 100).to_i
      end
      data
    end

    def distinct_values(type)
      Vendor.distinct type
    end
  end
end
