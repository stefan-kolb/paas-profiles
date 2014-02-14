module LayoutHelper
  CONTINENT_CODES = {
      'AF' => 'Africa',
      'AS' => 'Asia',
      'EU' => 'Europe',
      'NA' => 'North America',
      'OC' => 'Oceania',
      'SA' => 'South America'
  }

  def continent_by_code(code)
    CONTINENT_CODES[code]
  end

end