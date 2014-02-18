require_relative '../../models/vendor'
require_relative '../../models/snapshot'
require_relative '../../models/statistics/runtime_trend'
require_relative '../version'
require_relative '../helper/statistics_helper'

# Base class that contains shared attributes and methods for specific chart implementations
class Charts
  extend StatisticsHelper

  # TODO make dynamic
  LATEST = {
      'php' => '5.5.9',
      'java' => '1.7.0_51',
      'ruby' => '2.1.0',
      'node' => '0.10.25',
      'python' => '3.3.4',
      'dotnet' => '4.5',
      'perl' => '5.18.2',
      'go' => '1.2',
      'scala' => '2.10.3',
      'erlang' => 'R16B03',
      'clojure' => '1.5.1'
  }
  # Standard color array for Highcharts
  COLORS = %w( #2f7ed8 #0d233a #8bbc21 #910000 #1aadce #492970 #f28f43 #77a1e5 #c42525 #a6c96a )

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
      # TODO if property is not mandatory this will lead to false % distribution, e.g. middleware
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

    return data
  end

  # todo define no threshold = false or 0? -> tests
  def support_columndata(type, threshold = 0.05)
    data = []

    distinct_values(type).each_with_index do |l, i|
      count = Vendor.where(type => l).count

      data << {name: l, y: (count / vendor_count.to_f * 100).to_i, drilldown: {
          name: "#{l.capitalize} Versions",
          categories: distinct_versions(l),
          latest: LATEST[l],
          data: distinct_versions_data(l)
      }
      }
    end

    # capitalize each word
    data.each { |e| e[:name].capitalize! }
    # sort by count descending
    data.sort! { |x, y| y[:y] <=> x[:y] }
    # % threshold
    if threshold
      sum = 0
      data.each { |e| sum += e[:y] }
      others = {name: 'Others', y: 0}

      data.delete_if do |e|
        if (e[:y].to_f < (threshold * 100.0))
          # aggregate those below the threshold TODO + value or only +1 for others?
          others[:y] += e[:y]
          true
        end
      end

      data << others unless others[:y] == 0
    end

    # colors
    data.each_with_index do |l, i|
      l[:color] = COLORS[i%COLORS.length]
      if l[:name] != 'Others'
        l[:drilldown][:color] = COLORS[i%COLORS.length]
      end
    end

    return data.to_json
  end

  def language_count language
    Vendor.where('runtimes.language' => language).length
  end

  def distinct_versions language
    return distinct_versions_data(language).collect { |x| x[0] }
  end

  def distinct_versions_data language
    # TODO duplicate languages in profile will cause false results
    vendors = Vendor.where('runtimes.language' => language)
    data = Hash.new

    vendors.each do |vendor|
      vendor['runtimes'].each do |rt|
        if rt['language'] == language
          if rt['versions'].blank?
            if data.has_key? 'Unknown'
              data['Unknown'] += 1
            else
              data['Unknown'] = 1
            end
          else
            rt['versions'].each do |v|
              # TODO uniform version format, filter empty versions
              v = Version.new(v).unify

              if data.has_key? v
                data[v] += 1
              else
                data[v] = 1
              end
            end
          end
        end
      end
    end

    # TODO sort bug 0.11 > 0.2
    data = data.sort { |x, y| x <=> y }
    # TODO rundungsfehler bug?!
    data.each do |v|
      v[1] = (v[1] / language_count(language).to_f * 100).to_i
    end
    data
  end

  def distinct_values type
    Vendor.distinct type
  end
end