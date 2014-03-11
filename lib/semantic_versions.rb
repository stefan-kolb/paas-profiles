module SemanticVersions
  # options
  WILDCARD = '*'

  class Version
    include Comparable

    attr_accessor :major, :minor, :patch

    # creation
    class << self
      def parse(str)
        arr = /^((\*|\d+)\.)?((\*|\d+)\.)?(\*|\d+)$/.match(str)[0].split('.')

        # TODO only define one of the version properties
        if arr.size != 3
          raise ArgumentError 'Wrong version format'
        end

        # replace wildcards
        arr.each do |v|
          if v == '*'
            v = -1
          end
        end

        v = Version.new
        v.major = arr[0].to_i
        v.minor = arr[1].to_i
        v.patch = arr[2].to_i
        v
      end
    end

    # comparison
    def <=>(anOther)
      if !wildcards?(self) && !wildcards?(anOther)
        return major <=> anOther.major unless (major <=> anOther.major) == 0
        return minor <=> anOther.minor unless (minor <=> anOther.minor) == 0
        return patch <=> anOther.patch unless (patch <=> anOther.patch) == 0
        return 0
      else
        # wildcard comparison unclear
        return nil
      end
    end

    # to_s
    def to_s
      major.to_s << '.' << minor.to_s << '.' << patch.to_s
    end

    def inspect
      to_s
    end

    private

    def wildcards?(version)
      if version.major == -1 || version.minor == -1 || version.patch == -1
        true
      else
        false
      end
    end
  end
end

# TODO group_by override and collect all versions that match
# wie gruppiere ich am ebsten, sehr unklar entweder 3.* alle 3.x reinpacken oder 3.* auf alle 3.x draufrechnen ka....