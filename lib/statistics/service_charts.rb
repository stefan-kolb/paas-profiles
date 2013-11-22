require_relative 'charts'

class ServiceCharts
  def support_columndata
    data = Charts.new.support_columndata 'services.native.name', 0.02

    return data
  end

  def support_categories
    arr = []
    JSON.parse(support_columndata).each { |e| arr << e['name'] }
    arr
  end
end