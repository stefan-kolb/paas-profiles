require_relative 'charts'

class LanguageCharts
  def support_columndata threshold=0.05
    data = Charts.new.support_columndata 'runtimes.language', threshold

    return data
  end

  def support_categories threshold=0.05
    arr = []
    JSON.parse(support_columndata threshold).each { |e| arr << e['name'] }
    arr
  end

  def count_piedata
    data = []
    one = Vendor.where(:runtimes.with_size => 1)
    data << ['Language-specific', one.length]
    data << ['Polyglot', Vendor.count - one.length]

    return data
  end
end