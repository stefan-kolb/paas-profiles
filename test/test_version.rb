require 'minitest/autorun'

require_relative '../lib/semantic_versions'

class TestVersion < MiniTest::Test
  include SemanticVersions

  def test_parse
    v = Version.parse '1.1.1'
    assert_equal(1, v.major, 'Unexpected major version')
    assert_equal(1, v.minor, 'Unexpected minor version')
    assert_equal(1, v.patch, 'Unexpected patch version')
  end

  def test_to_s
    v = Version.parse '1.1.1'
    assert_equal('1.1.1', v.to_s, 'Unexpected string output')
  end

  def test_standard_comparison
    v2 = Version.parse '1.1.1'

    # = equal
    v1 = Version.parse '1.1.1'
    assert_equal(0, v1 <=> v2, "#{v1} should be equal #{v2}")

    # < less than
    # patch
    v1 = Version.parse '1.1.0'
    assert_equal(-1, v1 <=> v2, "#{v1} should be less than #{v2}")
    # minor
    v1 = Version.parse '1.0.1'
    assert_equal(-1, v1 <=> v2, "#{v1} should be less than #{v2}")
    # major
    v1 = Version.parse '0.1.1'
    assert_equal(-1, v1 <=> v2, "#{v1} should be less than #{v2}")

    # > greater than
    # patch
    v1 = Version.parse '1.1.2'
    assert_equal(1, v1 <=> v2, "#{v1} should be greater than #{v2}")
    # minor
    v1 = Version.parse '1.2.1'
    assert_equal(1, v1 <=> v2, "#{v1} should be greater than #{v2}")
    # major
    v1 = Version.parse '2.1.1'
    assert_equal(1, v1 <=> v2, "#{v1} should be greater than #{v2}")
  end

  def test_wildcard_comparison
    # TODO unclear atm
    v1 = Version.parse '*.*.*'
    v2 = Version.parse '2.1.1'
    assert_nil(v1 <=> v2, "Comparison of versions including wildcards not defined at the moment")
  end

end