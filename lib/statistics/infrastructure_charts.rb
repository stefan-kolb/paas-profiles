require_relative 'charts'

class InfrastructureCharts
  def support_piedata
    data = Charts.new.support_piedata 'infrastructures.continent', false

    data.each do |e|
      case e[0].upcase!
        when "EU"
          e[0] = "Europe"
        when "SA"
          e[0] = "South America"
        when "NA"
          e[0] = "North America"
        when "AS"
          e[0] = "Asia"
        when "OC"
          e[0] = "Oceania"
        else
          e[0] = "Africa"
      end
    end

    # missing continents
    data << ['Africa', 0]

    return data
  end
end