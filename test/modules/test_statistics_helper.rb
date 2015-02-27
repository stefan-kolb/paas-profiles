require 'minitest/autorun'

require_relative '../../lib/helper/statistics_helper'

class DummyClass; extend StatisticsHelper; end

class TestStatisticsHelper < MiniTest::Test

  def test_mean
    array = [2, 4, 5]
    assert_equal(3.7, DummyClass.mean(array), 'Unexpected mean value')
  end

  def test_mean_of_one_element
    array = [2]
    assert_equal(2, DummyClass.mean(array), 'Unexpected mean value')
  end

  def test_mean_of_empty_array
    assert_raises(ArgumentError) { DummyClass.mean([]) }
  end

  def test_mode_unimodal
    array = [1, 2, 2, 3]
    assert_equal([2], DummyClass.mode(array), 'Unexpected mode value')
  end

  def test_mode_multimodal
    array = [1, 2, 2, 3, 3, 4]
    assert_equal([2, 3], DummyClass.mode(array), 'Unexpected mode value')
  end

  def test_mode_of_one_element
    array = [2]
    assert_equal([2], DummyClass.mode(array), 'Unexpected mode value')
  end

  def test_mode_of_empty_array
    assert_raises(ArgumentError) { DummyClass.mode([]) }
  end

  def test_median_odd_numbers
    array = [1, 2, 3]
    assert_equal(2, DummyClass.median(array), 'Unexpected median value')
  end

  def test_median_even_numbers
    array = [1, 2, 3, 4]
    assert_equal(2.5, DummyClass.median(array), 'Unexpected median value')
  end

  def test_median_of_one_element
    array = [2]
    assert_equal(2, DummyClass.median(array), 'Unexpected median value')
  end

  def test_median_of_empty_array
    assert_raises(ArgumentError) { DummyClass.median([]) }
  end

end