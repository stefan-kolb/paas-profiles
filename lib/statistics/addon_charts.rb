require_relative 'charts'

require_relative '../../models/vendor'

class AddonCharts < Charts
  attr_reader :addon_count, :mean_count, :mode_count, :median_count

  def initialize
    #compute_averages
  end

  def addon_count
    addon_count ||= Vendor.distinct('services.addon.name').length
  end

  def support_chart( type='pie' )
    data = []

    if type.eql? 'pie'
      addon_support = Vendor.where('services.addon'.size: '$gt' => { '$size': 0 }).count
      data << ['Supported', addon_support]
      data << ['Not Supported', vendor_count - addon_support]
    end

    data
  end

  private

  def compute_averages
    # TODO only count when they have add-ons!
    addon_count = Vendor.where(:services.addon.exists => true).collect { |v| v.service.addons.count }

    @mean_count = Charts.mean(addon_count)
    @median_count = Charts.median(addon_count)
    @mode_count = Charts.mode(addon_count)
  end
end