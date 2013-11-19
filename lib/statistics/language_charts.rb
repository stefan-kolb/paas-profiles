require_relative '../../models/vendor'

class LanguageCharts
  def language_support_piedata
    languages = []

    distinct_languages.each do |l|
      count = count_language l
      languages << [l, count]
    end

    # capitalize
    languages.each { |e| e[0].capitalize! }
    # sort by count ascending
    languages.sort! { |x,y| y[1] <=> x[1] }
    # 5 % threshold
    sum = 0
    languages.each { |e| sum += e[1] }
    others = ['Others', 0]

    languages.delete_if do |e|
      if (e[1].to_f / sum) < 0.05
        others[1] += e[1]
        true
      end
    end
    languages << others

    return languages
  end

  def distinct_languages
    Vendor.distinct('runtimes.language')
  end

  def count_language language
    Vendor.where('runtimes.language' => language).count
  end
end