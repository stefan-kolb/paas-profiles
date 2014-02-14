require 'json'
require 'iso_country_codes'

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

  def country_by_code(code)
    country = IsoCountryCodes.find(code)
    country.name unless country.nil?
  end

end