require 'minitest/autorun'

module Profiles
  class TestImages < MiniTest::Test
    PROFILE_DIR = File.join(__dir__, '..', 'profiles')
    IMAGE_DIR = File.join(__dir__, '..', 'public', 'img', 'vendor')

    # for every vendor a small and a big logo must be available
    def test_logo_for_profile
      Dir.glob(File.join(PROFILE_DIR, '*.json')) do |file|
        vendor = File.basename(file, '.json')
        default_img = File.join(IMAGE_DIR, "#{vendor}.png")
        big_img = File.join(IMAGE_DIR, "#{vendor}_big.png")

        assert(File.exist?(default_img), "No small logo available for #{vendor}")
        assert(File.exist?(big_img), "No big logo available for #{vendor}")
      end
    end

    # def test_profile_for_logo
    #   Dir.glob(File.join(IMAGE_DIR, '*.png')) do |file|
    #     vendor = if File.basename(file, '.png').end_with? 'big'
    #                File.basename(file, '.png').gsub('_big', '')
    #              else
    #                File.basename(file, '.png')
    #              end
    #
    #     profile = File.join(PROFILE_DIR, "#{vendor}.json")
    #
    #     assert(File.exist?(profile), "No profile available for #{vendor}")
    #  end
    # end
  end
end
