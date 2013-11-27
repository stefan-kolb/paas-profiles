require_relative 'charts'

class ServiceChart
  attr_reader :service_count, :avg_service_count

  def initialize
    @service_count = Vendor.distinct('services.native.name').length
    # avg services count
    sum_services = 0
    #Vendor.all.each { |v| sum_services += v.service.natives.count }
    #@avg_service_count = (sum_services / Charts.new.vendor_count.to_f).round(1)
  end

  def support_columndata threshold=0.04
    data = Charts.new.support_columndata 'services.native.name', threshold

    return data
  end

  def support_categories threshold=0.04
    arr = []
    JSON.parse(support_columndata threshold).each { |e| arr << e['name'] }
    arr
  end
end