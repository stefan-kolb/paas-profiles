require_relative 'charts'
require_relative '../../models/statistics'

class DataCharts < Charts
  def verification_chart( type='pie' )
    data = []

    if type.eql? 'pie'
      data << ['Vendor', verified_count]
      data << ['Community', vendor_count - verified_count]
    end

    data
  end
end