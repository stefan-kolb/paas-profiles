class Version
  include Comparable

  attr :str
  attr :major, :minor, :patch

  # http://semver.org/
  #java > 1.3.0: http://www.oracle.com/technetwork/java/javase/versioning-naming-139433.html
  def <=>(anOther)
    return major <=> anOther.major unless (major <=> anOther.major) == 0
    return minor <=> anOther.minor unless (minor <=> anOther.minor) == 0
    return patch <=> anOther.patch unless (patch <=> anOther.patch) == 0
  end

  def initialize(str)
    # auto match type of version
    # define language and only use this schema
    # define wildcard
    @str = str
    arr = /\d+\.\d+\.\d+/.match(@str)[0].split('.')
    @major = arr[0]
    @minor = arr[1]
    @patch = arr[2]

  end

  def inspect
    @str
  end
end