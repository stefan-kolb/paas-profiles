require_relative 'charts'
require_relative '../../models/statistics'

# Chart class for language runtime specific statistics
class LanguageCharts < Charts
  attr_reader :language_count, :mean_count, :mode_count, :median_count, :support_data, :support_categories

  def initialize
    # TODO run all computation once?
    compute_averages
  end

  def language_count
    @language_count ||= Vendor.distinct('runtimes.language').length
  end

  def support_columndata threshold=0.05
    @support_data ||= Charts.new.support_columndata 'runtimes.language', false
  end

  def support_categories threshold=0.05
    unless @support_categories
      arr = []
      JSON.parse(support_columndata threshold).each { |e| arr << e['name'] }
      @support_categories = arr
    end
    @support_categories
  end

  def count_piedata
    data = []
    one = Vendor.where(:runtimes.with_size => 1).count
    data << ['Language-specific', one]
    data << ['Polyglot', vendor_count - one]

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

  private

  def compute_averages
    runtime_count = Vendor.all.collect { |v| v.runtimes.count }

    # mean
    sum_languages = 0
    runtime_count.each { |v| sum_languages += v }
    @mean_count = (sum_languages / vendor_count.to_f).round(1)
    # median
    runtime_count.sort!
    len = runtime_count.length
    @median_count = (runtime_count[(len - 1) / 2] + runtime_count[len / 2]) / 2.0
    # mode
    @mode_count = runtime_count.group_by { |n| n }.values.max_by(&:size).first
  end

end