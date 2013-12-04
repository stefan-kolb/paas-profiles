require_relative 'charts'
require_relative '../../models/statistics'

class LanguageCharts < Charts
  attr_reader :language_count, :mean_count, :mode_count, :median_count

  def language_count
    @language_count ||= Vendor.distinct('runtimes.language').length
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

  def get_trend threshold=0.1
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

    # TODO now, aggregate others?
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
    data << { name: 'Polyglot', data: [] }
    data << { name: 'Language-specific', data: [] }
    data << { name: 'Distinct languages', data: [] }

    Statistics.all.each do |e|
      data.find { |e| e[:name] == 'Polyglot' }[:data] << e.polyglot_count
      data.find { |e| e[:name] == 'Language-specific' }[:data] << e.lspecific_count
      data.find { |e| e[:name] == 'Distinct languages' }[:data] << e.language_count
    end
    data.to_json
  end

end