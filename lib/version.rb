module Profiles
  class Version
    include Comparable

    attr_reader :str, :type
    attr_reader :major, :minor, :patch

    # http://semver.org/
    # java > 1.3.0: http://www.oracle.com/technetwork/java/javase/versioning-naming-139433.html
    def <=>(other)
      return major <=> other.major unless (major <=> other.major).zero?
      return minor <=> other.minor unless (minor <=> other.minor).zero?
      return patch <=> other.patch unless (patch <=> other.patch).zero?
    end

    def match(other)
      return true if anOther.major == '*'
      return true if (major <=> other.major).zero? && other.minor == '*'
      return major <=> other.major unless (major <=> other.major).zero?
      return minor <=> other.minor unless (minor <=> other.minor).zero?
      true
    end

    def unify
      return 'Unknown' unless major
      return major unless minor
      major << '.' << minor
    end

    def initialize(str, type = nil)
      @type = type
      # auto match type of version
      # define language and only use this schema
      # define wildcard
      @str = str
      arr = /^((\*|\d+)\.)?((\*|\d+)\.)?(\*|\d+)$/.match(@str)[0].split('.')
      @major = arr[0]
      @minor = arr[1]

    rescue StandardError => e
      puts 'Error in version.rb ' << e.to_s
    end

    def latest?
      result = RuntimeVersion.where(name: type).first
      latest = result['version'] unless result.nil?
      return true unless /#{@str}/.match(latest).nil?
      false
    end

    def self.latest(language)
      result = RuntimeVersion.where(name: language).first
      return result['version'] unless result.nil?
      'unknown'
    end

    def inspect
      @str
    end
  end
end
