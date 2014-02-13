require_relative 'charts'
require_relative '../../models/statistics'
require_relative '../../models/statistics/data_stats'

class DataCharts < Charts
  attr_reader :total_vendors

  def total_vendors
    puts Dir["/../../profiles/**/*"].length
    @total_vendors ||= vendor_count + Dir["../../profiles/**/*"].length
  end

  def verification_chart( type='pie' )
    data = []

    if type.eql? 'pie'
      data << ['Vendor', verified_count]
      data << ['Community', vendor_count - verified_count]
    end

    data
  end

  def overtime_a
     DataTrend.all.asc(:revision).collect { |i| [ "#{i.revision.strftime("%Y-%m-%dT")}", i.active_count ] }
  end

  def overtime_e
    DataTrend.all.asc(:revision).collect { |i| [ "#{i.revision.strftime("%Y-%m-%dT")}", i.eol_count ] }
  end

  def overtime_all
    DataTrend.all.asc(:revision).collect { |i| [ "#{i.revision.strftime("%Y-%m-%dT")}", i.eol_count + i.active_count] }
  end
end