require_relative 'charts'

class ScalingCharts
  def vertical_piedata
    data = []

    up = Vendor.where('scaling.vertical' => true).count

    data << ['Vertical', up] << ['', Vendor.count - up]
  end

  def horizontal_piedata
    data = []

    out = Vendor.where('scaling.horizontal' => true).count

    data << ['Horizontal', out] << ['', Vendor.count - out]
  end

  def auto_piedata
    data = []

    auto = Vendor.where('scaling.auto' => true).count

    data << ['Automatic', auto] << ['', Vendor.count - auto]
  end
end