require_relative 'charts'

class LanguageChart
  attr_reader :language_count, :avg_language_count

  def initialize
    @language_count = Vendor.distinct('runtimes.language').length
    # avg language count
    sum_languages = 0
    Vendor.all.each { |v| sum_languages += v.runtimes.count }
    @avg_language_count = (sum_languages / Charts.new.vendor_count.to_f).round(1)
  end

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