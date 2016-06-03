class SabayonMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    data = []
    if ENV['ACME_KEY'] && ENV['ACME_TOKEN']
      data << { key: ENV['ACME_KEY'], token: ENV['ACME_TOKEN'] }
    else
      ENV.each do |k, v|
        d = k.match(/^ACME_KEY_([0-9]+)/)
        next unless d
        index = d[1]

        data << { key: v, token: ENV["ACME_TOKEN_#{index}"] }
      end

      data.each do |e|
        if env['PATH_INFO'] == "/.well-known/acme-challenge/#{e[:token]}"
          return [200, { 'Content-Type' => 'text/plain' }, [e[:key]]]
        end
      end

      @app.call(env)
    end
  end
end
