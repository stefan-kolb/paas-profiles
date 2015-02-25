require 'minitest/autorun'

class TestImages < MiniTest::Test

  # for every vendor a small and a big logo must be available
  def test_vendor_logos
    Dir.glob(File.dirname(__FILE__) + '/../profiles/*.json') do |file|
      vendor = File.basename(file, '.json')
      assert(File.exist?(File.dirname(__FILE__) + '/../public/img/vendor/' + vendor + '.png'), "No small logo available for #{vendor}")
      assert(File.exist?(File.dirname(__FILE__) + '/../public/img/vendor/' + vendor + '_big.png'), "No big logo available for #{vendor}")
    end
  end

end