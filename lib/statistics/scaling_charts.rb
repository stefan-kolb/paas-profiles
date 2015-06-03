require_relative 'charts'

module Profiles
  class ScalingCharts
    def support_columndata
      data = []

      up = Vendor.where('scaling.vertical' => true).count
      out = Vendor.where('scaling.horizontal' => true).count
      auto = Vendor.where('scaling.auto' => true).count
      no = Vendor.where('scaling.auto' => false, 'scaling.vertical' => false, 'scaling.horizontal' => false).count
      hv = Vendor.where('scaling.vertical' => true, 'scaling.horizontal' => true).count
      hva = Vendor.or({ '$and' => [{ 'scaling.vertical' => true }, { 'scaling.auto' => true }] }, '$and' => [{ 'scaling.horizontal' => true }, { 'scaling.auto' => true }]).count

      data << { name: 'Vertical', y: (up / 67.to_f * 100).to_i }
      data << { name: 'Horizontal', y: (out / 67.to_f * 100).to_i }
      data << { name: 'Automatic', y: (auto / 67.to_f * 100).to_i }
      data << { name: 'No Scaling', y: (no / 67.to_f * 100).to_i }
      data << { name: 'Horizontal + Vertical', y: (hv / 67.to_f * 100).to_i }
      data << { name: 'Horizontal or Vertical and Auto', y: (hva / 67.to_f * 100).to_i }

      data.to_json
    end

    def support_categories
      arr = []
      JSON.parse(support_columndata).each { |e| arr << e['name'] }
      arr
    end
  end
end
