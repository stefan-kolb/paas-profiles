require_relative '../../models/vendor'
require_relative '../version'

class Charts
  attr_reader :vendor_count, :colors

  def initialize
    @vendor_count = Vendor.count
    @colors = [
        '#2f7ed8',
        '#0d233a',
        '#8bbc21',
        '#910000',
        '#1aadce',
        '#492970',
        '#f28f43',
        '#77a1e5',
        '#c42525',
        '#a6c96a'
    ]
  end

  def support_piedata( type, threshold = 0.05 )
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
    data.sort! { |x,y| y[1] <=> x[1] }
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

  def support_columndata( type, threshold = 0.05 )
    data = []

    distinct_values(type).each_with_index do |l, i|
      count = Vendor.where(type => l).count
      # TODO bars in versions all the same color, best color of toplevel language
      data << { name: l, y: (count / vendor_count.to_f * 100).to_i, drilldown: {
          name: "#{l.capitalize} Versions",
          categories: distinct_versions(l),
          data: distinct_versions_data(l)
        }
      }
    end

    # capitalize each word
    data.each { |e| e[:name].capitalize! }
    # sort by count ascending
    data.sort! { |x,y| y[:y] <=> x[:y] }
    # 5 % threshold
    if threshold
      sum = 0
      data.each { |e| sum += e[:y] }
      others = { name: 'Others', y: 0 }

      data.delete_if do |e|
        if (e[:y].to_f / sum) < threshold
          # aggregate those below the threshold TODO + value or only +1 for others?
          others[:y] += e[:y]
          true
        end
      end
      data << others
    end

    # colors
    data.each_with_index do |l,i|
      l[:color] = @colors[i]
      if l[:name] != 'Others'
        l[:drilldown][:color] = @colors[i]
      end
    end

    return data.to_json
  end

  # sort from newest to oldest version + unknown?
  def distinct_versions language
    versions = []
    vendors = Vendor.where('runtimes.language' => language)

    vendors.each do |vendor|
      vendor['runtimes'].each do |rt|
        if rt['language'] == language
          if rt['versions'].nil? || rt['versions'].empty?
            unless versions.include? 'Unknown'
              versions << 'Unknown'
            end
          end
          rt['versions'].each do |v|
            # TODO uniform version format, filter empty versions
            v = Version.new(v).unify

            unless versions.include? v
              versions << v
            end
          end
        end
      end
    end

    return versions
  end

  def distinct_versions_data language
    versions = []
    vendors = Vendor.where('runtimes.language' => language)
    data = []

    vendors.each do |vendor|
      vendor['runtimes'].each do |rt|
        if rt['language'] == language
          if rt['versions'].empty?
            # TODO bug will not work will always return first element
            if versions.include? 'Unknown'
              data[versions.find_index('Unknown')] += 1
            else
              versions << 'Unknown'
              data << 1
            end
          else
            rt['versions'].each do |v|
              # TODO uniform version format, filter empty versions
              v = Version.new(v).unify

              if versions.include? v
                data[versions.find_index(v)] += 1
              else
                versions << v
                data << 1
              end
            end
          end
        end
      end
    end

    data = data.collect { |v| (v / vendors.length.to_f * 100).to_i }

    return data
  end

  def distinct_values type
    Vendor.distinct type
  end
end