class Version
  include Comparable

  attr :str, :type
  attr :major, :minor, :patch

  # TODO make dynamic
  LATEST = {
      'php' => '5.5',
      'java' => '1.8',
      'ruby' => '2.1',
      'node' => '0.10',
      'python' => '3.4',
      'dotnet' => '4.5',
      'perl' => '5.18',
      'go' => '1.3',
      'scala' => '2.11',
      'erlang' => '17.0',
      'clojure' => '1.6',
      'groovy' => '2.3',
      'apex' => '',
      'cobol' => '2002',
      'lua' => '5.2',
      'dart' => '1.2',
  }

  # http://semver.org/
  #java > 1.3.0: http://www.oracle.com/technetwork/java/javase/versioning-naming-139433.html
  def <=>(anOther)
    return major <=> anOther.major unless (major <=> anOther.major) == 0
    return minor <=> anOther.minor unless (minor <=> anOther.minor) == 0
    return patch <=> anOther.patch unless (patch <=> anOther.patch) == 0
  end

  def match(anOther)
    return true if anOther.major ==  '*'
    return true if (major <=> anOther.major) == 0 && anOther.minor ==  '*'
    return major <=> anOther.major unless (major <=> anOther.major) == 0
    return minor <=> anOther.minor unless (minor <=> anOther.minor) == 0
    return true
  end

  def unify
    if major

      return major << '.' << minor
    else
      return 'Unknown'
    end
  end

  def initialize(str, type=nil)
    @type = type
    # auto match type of version
    # define language and only use this schema
    # define wildcard
    @str = str
    arr = /^((\*|\d+)\.)?((\*|\d+)\.)?(\*|\d+)$/.match(@str)[0].split('.')
    @major = arr[0]
    @minor = arr[1]

    rescue
    # ignore
  end

  def latest?
    return true unless @str.match(LATEST[type]).nil?
    false
  end

  def inspect
    @str
  end
end