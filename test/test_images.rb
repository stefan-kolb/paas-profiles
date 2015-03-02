require 'minitest/autorun'

module Profiles
  class TestImages < MiniTest::Test
    # for every vendor a small and a big logo must be available
    def test_vendor_logos
      Dir.glob(__dir__ << '/../profiles/*.json') do |file|
        vendor = File.basename(file, '.json')
        default_img = __dir__ << '/../public/img/vendor/' + vendor + '.png'
        big_img = __dir__ << '/../public/img/vendor/' + vendor + '_big.png'

        assert(File.exist?(default_img), "No small logo available for #{vendor}")
        assert(File.exist?(big_img), "No big logo available for #{vendor}")
      end
    end
  end
end
