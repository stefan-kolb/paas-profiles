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

  def get_trend threshold=0.05
    data = []

    languages = RuntimeTrend.distinct(:language)

    languages.each do |l|
      RuntimeTrend.where(language: l).order_by(:revision.asc).each do |d|
        entry = data.find { |e| e[:name].downcase == d.language }

        if entry
          entry[:data] << d.count
        else
          data << { name: d.language, data: [ d.count ] }
        end
      end
    end

    # todo percentage threshold
    data.reject! { |i| i[:data].last <= 8 }

    return data.to_json
  end

  def trend_categories
    Snapshot.all().only(:revision).collect { |e| e.revision.strftime("%m-%Y") }
  end
end