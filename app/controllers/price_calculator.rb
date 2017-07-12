require_relative '../models/pricing/vendor_pricing'
require 'money'

class PriceCalculator

  @params

  def initialize(parameters)
    @params = parameters
  end

  def calculatePrices()
    usedParams = 0
    # Count specified paramteters
    @params.keys.each do |formParam|
      if formParamWasSelected(formParam)
        usedParams += 1
      end
    end

    # Hash with key(vendor) and value(price)
    results = Hash.new

    Pricing::VendorPricing.each do |vendor|
      # Check every tarif
      tarifs = Hash.new
      bundles = Hash.new

      vendor["tarif"].each do |tarif|
        tarifInfo = Hash.new
        tarifInfo["price"] = 0
        pricing = 0
        found = 0
        paramHash = Hash.new
        # Check every parameter of the tarif
        tarif["parameter"].each do |priceParam|
          bundleNr = priceParam["bundle"]

          #calculate indepenent Parameters
          if bundleNr == nil
            @params.keys.each do |formParam|
              if formParamWasSelected(formParam)
                # Check wether requested parameter matches wirth parameter in tarif and wether the upper bound is not exceeded
                if priceParam["name"] == formParam && @params[formParam].to_i <= priceParam["upper_bound"]
                  priceParam["price"].each do |price|
                    # Parameter is binary
                    if @params[formParam] == "on" && priceParam["unit"] == "binary"
                      pricing += calculatePriceWithInterval(price["price_per_unit"], tarif["interval"])
                      paramHash[formParam] = ""
                    else
                      roundedValue = roundValue(@params[formParam].to_i, price["pricing_unit"])
                      if roundedValue >= price["minimum"] && roundedValue <= price["maximum"]
                        pricing += calculatePriceWithInterval((price["price_per_unit"] * roundedValue / price["pricing_unit"]), tarif["interval"])
                        paramHash[formParam] = createParameterString(roundedValue, priceParam["unit"])
                      end
                    end
                  end
                  found += 1
                end
              end
              tarifInfo["price"] = pricing
            end
          else
            # non independent parameters
            if !bundles.key?(priceParam["bundle"])
              bundles[bundleNr] = Hash.new
              bundles[bundleNr]["parameters"] = Array.new
              bundles[bundleNr]["price"] = 0
              bundles[bundleNr]["selected"] = false
            end
            bundles[bundleNr]["parameters"].push priceParam

            @params.keys.each do |formParam|
              if formParamWasSelected(formParam)
                if priceParam["name"] == formParam && @params[formParam].to_i <= priceParam["upper_bound"]
                  priceParam["price"].each do |price|
                    tmpPrice = 0;
                    if @params[formParam] == "on" && priceParam["unit"] == "binary"
                      tmpPrice = calculatePriceWithInterval(price["price_per_unit"], tarif["interval"])
                      setPriceIfHigher(tmpPrice, bundleNr, bundles)
                      setIntervalIfHigher(1, bundleNr, bundles)
                      bundles[bundleNr]["selected"] = true
                      found += 1
                    else
                      roundedValue = roundValue(@params[formParam].to_i, price["pricing_unit"])
                      if roundedValue >= price["minimum"] && roundedValue <= price["maximum"]
                        tmpPrice = calculatePriceWithInterval((price["price_per_unit"] * roundedValue / price["pricing_unit"]), tarif["interval"])
                        setPriceIfHigher(tmpPrice, bundleNr, bundles)
                        setIntervalIfHigher(roundedValue / price["pricing_unit"], bundleNr, bundles)
                        bundles[bundleNr]["selected"] = true
                        found += 1
                      end
                    end
                  end
                end
              end
            end
          end
        end
        # process bundles
        bundles.keys.each do |key|
          if bundles[key]["selected"]
            bundles[key]["parameters"].each do |par|
              amount = 0
              par["price"].each do |p|
                amount = p["pricing_unit"].to_i * bundles[key]["interval"].to_i
              end
              paramHash[par["name"]] = createParameterString(amount, par["unit"])
            end
          end
        end
        tarifInfo["params"] = paramHash
        tarifInfo["name"] = tarif["name"]
        bundles.keys.each do |key|
          tarifInfo["price"] += bundles[key]["price"]
        end
        # Check wether all requested parameters can be found in a tarif
        if found >= usedParams && found != 0
          addTarifIfCheaper(results, tarifInfo, vendor["name"])
        end
      end
    end
    results = results.sort_by{|vendor, tar| tar["price"]}
    return results
  end



  def formParamWasSelected(param)
    return @params[param] != nil && @params[param] != "" && @params[param] != 0
  end

  #rounds value to a value that is divisible by the pricing unit
  def roundValue (value, pricing_unit)
    if value % pricing_unit == 0
      return value
    end
    return value + pricing_unit - (value % pricing_unit)
  end

  def createParameterString (parameter, unit)
    if unit == nil
      return parameter.to_s
    elsif unit == "binary"
      return ""
    else
      return parameter.to_s + " " + unit
    end
  end

  def setPriceIfHigher(value, bundleNr, bundles)
    if bundles[bundleNr]["price"] == nil
      bundles[bundleNr]["price"] = value
    else
      if bundles[bundleNr]["price"] < value
        bundles[bundleNr]["price"] = value
      end
    end
  end

  def setIntervalIfHigher(value, bundleNr, bundles)
    if bundles[bundleNr]["interval"] == nil
      bundles[bundleNr]["interval"] = value
    else
      if bundles[bundleNr]["interval"] < value
        bundles[bundleNr]["interval"] = value
      end
    end
  end

  def addTarifIfCheaper(results, tarif, vendor)
    if results[vendor] == nil || results[vendor]["price"] > tarif["price"]
      results[vendor] = tarif
    end
  end

  def calculatePriceWithInterval(price, interval)
    if interval == "monthly"
      return price
    elsif interval == "annually"
      return price / 12
    elsif intervall == "daily"
      return price * 30
    end
  end
end
