get '/api/vendor/:vendor' do
  content_type :json

  begin
    json = Vendor.find_by(name: /#{params[:vendor].gsub('_', '.')}/i).as_document.to_json(:except => '_id')
  rescue
    halt 404, 'No vendor found!'
  end
end

post '/api/match' do
  begin
    data = JSON.parse(request.body.read)
    # match this vendor
    # TODO validation
    lookup = Vendor.new(data)
  rescue
    halt 400, 'JSON request has a bad format!'
  end
  # initial query
  query = Vendor.all
  # matching
  # name
  #query = query.all(name: lookup.name)
  # revision
  # vendor verified
  # url
  # status
  query = query.all(status: lookup.status)
  # status since
  # hosting
  query = query.all(hosting: lookup.hosting)
  # pricing
  lookup.pricings.each do |p|
    query = query.and({ 'pricing.model' => p.model }, { 'pricing.period' => p.period })
  end
  # scaling
  if lookup.scaling
    query = query.all('scaling.vertical' => lookup.scaling.vertical)
    query = query.all('scaling.horizontal' => lookup.scaling.horizontal)
    query = query.all('scaling.auto' => lookup.scaling.auto)
  end
  # compliance
  query = query.all(compliance: lookup.compliance)
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
      query = query.all('infrastructures.country' => i.country)
    end
  end

  result = []
  query.each do |d|
    result << d.as_document.as_json
  end

  # TODO check versions on result
  res = result.dup
  lookup.runtimes.each do |runtime|
    runtime.versions.map! {|v| v.gsub! '*', '99' } unless runtime.versions
    runtime.versions.map! {|v| Versionomy.parse(v) } unless runtime.versions
    version_support = false

    result.each do |provider|
      provider['runtimes'].each do |r|
        if r['language'] == runtime['language']
          r['versions'].map! {|v| v.gsub! '*', '99' } unless r['versions']
          r['versions'].map! {|v| Versionomy.parse(v) } unless r['versions']

          runtime.versions.each do |v1|
            r['versions'].each do |v2|
              # TODO >= ==?
              if v2 >= v1
                version_support = true
              end
            end
          end
        end
      end
      res.delete(provider) unless version_support
    end
  end

  res.to_json(:except => '_id')
end