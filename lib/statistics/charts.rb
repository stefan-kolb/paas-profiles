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

  def distinct_values type
    Vendor.distinct type
  end
end