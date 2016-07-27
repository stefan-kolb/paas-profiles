module Profiles
  class Broker
    def match(data)
      # TODO: validation
      lookup = Vendor.new(data)
      # initial query
      query = Vendor.all

      # matching
      # name
      # query = query.all(name: lookup.name)
      # revision
      # vendor verified
      # url
      # status
      query = query.all(status: lookup.status) if lookup.status
      # status since
      # hosting
      # scaling
      if lookup.hosting
        query = query.all('hosting.public' => lookup.hosting.public) unless lookup.hosting.public.nil?
        query = query.all('hosting.private' => lookup.hosting.private) unless lookup.hosting.private.nil?
      end
      # pricing
      # lookup.pricings.each do |p|
      #   query = query.and({'pricing.model' => p.model}, {'pricing.period' => p.period})
      # end
      # scaling
      if lookup.scaling
        query = query.all('scaling.vertical' => lookup.scaling.vertical) unless lookup.scaling.vertical.nil?
        query = query.all('scaling.horizontal' => lookup.scaling.horizontal) unless lookup.scaling.horizontal.nil?
        query = query.all('scaling.auto' => lookup.scaling.auto) unless lookup.scaling.auto.nil?
      end
      # compliance FIXME structure changed
      # query = query.all(compliance: lookup.compliance)
      # runtimes
      lookup.runtimes.each do |r|
        query = query.all('runtimes.language' => r.language)
      end
      # middleware
      lookup.middlewares.each do |m|
        query = query.all('middleware.name' => m.name)
      end
      # frameworks
      lookup.frameworks.each do |f|
        query = query.all('frameworks.name' => f.name)
      end
      # services
      if lookup.service
        lookup.service.addons.each do |a|
          query = query.all('services.addon.name' => a.name)
        end
        lookup.service.natives.each do |n|
          query = query.all('services.native.name' => n.name)
        end
      end
      # extensibility
      query = query.where(extensible: lookup.extensible) if lookup['extensible']
      # infrastructures
      if lookup.infrastructures
        lookup.infrastructures.each do |i|
          query = query.all('infrastructures.continent' => i.continent)
          query = query.all('infrastructures.country' => i.country) if i.country
        end
      end

      result = []
      query.each do |d|
        result << d
      end

      # TODO: check versions on result
      res = result.dup
      lookup.runtimes.each do |runtime|
        runtime.versions.map! { |v| v.gsub! '*', '99' } unless runtime.versions
        runtime.versions.map! { |v| Versionomy.parse(v) } unless runtime.versions
        version_support = false

        result.each do |provider|
          provider['runtimes'].each do |r|
            next unless r['language'] == runtime['language']

            r['versions'].map! { |v| v.gsub! '*', '99' } unless r['versions']
            r['versions'].map! { |v| Versionomy.parse(v) } unless r['versions']

            runtime.versions.each do |v1|
              r['versions'].each do |v2|
                # TODO: >= ==?
                v2 >= v1 && version_support = true
              end
            end

          end
          res.delete(provider) unless version_support
        end
      end

      res
    end
  end
end
