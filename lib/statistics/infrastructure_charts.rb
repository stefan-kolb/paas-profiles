require_relative 'charts'

class InfrastructureCharts < Charts
  attr_reader :mean_count, :mode_count, :median_count

  def support_piedata
    data = Charts.new.get_piedata 'infrastructures.continent', false

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

  def mean_count

  end

  def median_count

  end

  def mode_count

  end

  def infras
    data = Hash.new

    Vendor.where(:infrastructures.exists => true).only(:infrastructures).each do |infra|
      if !infra.infrastructures.blank?
        infra.infrastructures.each do |i|
          if !i.country.empty?
            unless data[i.country].nil?
              data[i.country] += 1
            else
              data[i.country] = 1
            end
          end
        end
      end
    end

    data.to_json
  end


end