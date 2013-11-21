require_relative '../../models/vendor'

class Charts
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

    distinct_values(type).each do |l|
      count = Vendor.where(type => l).count
      data << { name: l, data: [] << count }
    end

    # capitalize
    data.each { |e| e[:name].capitalize! }
    # sort by count ascending
    data.sort! { |x,y| y[:data][0] <=> x[:data][0] }
    # 5 % threshold
    if threshold
      sum = 0
      data.each { |e| sum += e[:data][0] }
      others = { name: 'Others', data: [] << 0 }

      data.delete_if do |e|
        if (e[:data][0].to_f / sum) < threshold
          others[:data][0] += e[:data][0]
          true
        end
      end
      data << others
    end

    return data.to_json
  end

  def distinct_values type
    Vendor.distinct type
  end

  def max_count
    Vendor.count
  end
end