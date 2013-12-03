require_relative 'charts'

class LanguageChart
  attr_reader :language_count, :mean_count, :mode_count, :median_count

  def initialize
    @language_count = Vendor.distinct('runtimes.language').length
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

  def get_trend threshold=0.05
    data = []

    languages = RuntimeTrend.distinct(:language)

    languages.each do |l|
      RuntimeTrend.where(language: l).order_by(:revision.asc).each do |d|
        entry = data.find { |e| e[:name].downcase == d.language }

        if entry
          entry[:data] << d.percentage * 100
        else
          data << { name: d.language, data: [ d.percentage * 100 ] }
        end
      end
    end

    # TODO now
    # threshold
    data.reject! { |i| i[:data].last <= threshold * 100 }
    # capitalize
    data.each { |e| e[:name].capitalize! }
    # sort by count descending
    data.sort! { |x,y| y[:data].last <=> x[:data].last }

    return data.to_json
  end

  def trend_categories
    Snapshot.all().only(:revision).collect { |e| e.revision.strftime("%m-%Y") }
  end

  def get_count_trend
    data = []
    data << { name: 'polyglot', data: [ 0, 5, 10, 24, 39 ] }
    data << { name: 'language-specific', data: [ 10, 25, 45, 35, 28 ] }
    data << { name: 'total', data: [ 10, 30, 55, 59, 67 ] }
    data << { name: 'distinct languages', data: [ 3, 5, 9, 10, 15 ] }
    data.to_json
  end

  def mean_count
    unless @mean_count
      sum_languages = 0
      Vendor.all.each { |v| sum_languages += v.runtimes.count }
      @mean_count = (sum_languages / Charts.new.vendor_count.to_f).round(1)
    end
    @mean_count
  end

  def mode_count
    arr = Vendor.all.collect { |v| v.runtimes.count }
    arr.group_by { |n| n }.values.max_by(&:size).first
  end

  def median_count
    arr = Vendor.all.collect { |v| v.runtimes.count }
    sorted = arr.sort
    len = sorted.length
    return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end
end