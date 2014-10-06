require 'active_support'
require 'active_support/core_ext'

module StatisticsHelper
  def median(set)
    if set.blank?
      raise ArgumentError, 'There is no median for an empty set'
    end

    set.sort!
    (set[(set.length - 1) / 2] + set[set.length / 2]) / 2.0
  end

  def mode(set)
    if set.blank?
      raise ArgumentError, 'There is no mode for an empty set'
    end

    freq = set.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    uniq = set.uniq
    uniq.delete_if { |e| freq[e] < freq.values.max }

    uniq
  end

  def mean(set)
    if set.blank?
      raise ArgumentError, 'There is no mean for an empty set'
    end

    (set.reduce(:+) / set.length.to_f).round(1)
  end

  def variance(set)
    m = mean(set)
    set.map{ |sample| (m - sample) ** 2 }.inject(:+) / set.size.to_f
  end

  def standard_deviation(set)
    Math.sqrt(variance(set))
  end

  # TODO zusammenhangsmaße?
end