require 'minitest/autorun'

module Profiles
  class TestImages < MiniTest::Test
    # for every vendor a small and a big logo must be available
    def test_vendor_logos
      profile_dir = File.join(__dir__, '..', 'profiles', '*.json')
      img_dir = File.join(__dir__, '..', 'public', 'img', 'vendor')

      Dir.glob(profile_dir) do |file|
        vendor = File.basename(file, '.json')
        default_img = File.join(img_dir, "#{vendor}.png")
        big_img = File.join(img_dir, "#{vendor}_big.png")

        assert(File.exist?(default_img), "No small logo available for #{vendor}")
        assert(File.exist?(big_img), "No big logo available for #{vendor}")
      end
    end
  end
end
