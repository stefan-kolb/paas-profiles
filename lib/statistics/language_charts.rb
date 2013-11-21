require_relative 'charts'

class LanguageCharts
  def support_piedata
    data = Charts.new.support_columndata 'runtimes.language', 0.05

    return data
  end
end