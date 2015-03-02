module Profiles
  class StatisticsController < Base
    get '/statistics' do
      require_relative '../../lib/statistics/charts'
      require_relative '../../lib/statistics/infrastructure_charts'
      require_relative '../../lib/statistics/scaling_charts'
      require_relative '../../lib/statistics/language_charts'
      require_relative '../../lib/statistics/service_charts'

      @title = 'Platform as a Service | Statistics Dashboard'
      @lang_chart = LanguageCharts.new
      @service_chart = ServiceCharts.new
      @scaling_chart = ScalingCharts.new
      @teaser = 'Platform as a Service Statistics'

      erb :statistics_layout do
        erb :'statistics/overview'
      end
    end

    get '/statistics/languages' do
      require_relative '../../lib/statistics/charts'
      require_relative '../../lib/statistics/language_charts'

      @title = 'Platform as a Service | Language Statistics'
      @teaser = 'Runtime Languages'
      @chart = LanguageCharts.new

      erb :statistics_layout do
        erb :'statistics/languages'
      end
    end

    get '/statistics/services' do
      require_relative '../../lib/statistics/charts'
      require_relative '../../lib/statistics/service_charts'

      @title = 'Platform as a Service | Native Services Statistics'
      @teaser = 'Native Services'
      @chart = ServiceCharts.new

      erb :statistics_layout do
        erb :'statistics/services'
      end
    end

    get '/statistics/status' do
      require_relative '../../lib/statistics/charts'
      require_relative '../../lib/statistics/status_charts'

      @title = 'Platform as a Service | Maturity Statistics'
      @teaser = 'Maturity'
      @chart = StatusCharts.new

      erb :statistics_layout do
        erb :'statistics/status'
      end
    end

    get '/statistics/data' do
      require_relative '../../lib/statistics/charts'
      require_relative '../../lib/statistics/data_charts'

      @title = 'Platform as a Service | Data Statistics'
      @teaser = 'Data Quality'
      @chart = DataCharts.new

      erb :statistics_layout do
        erb :'statistics/data'
      end
    end

    get '/statistics/infrastructures' do
      require_relative '../../lib/statistics/charts'
      require_relative '../../lib/statistics/infrastructure_charts'

      @title = 'Platform as a Service | Infrastructure Statistics'
      @teaser = 'Public Infrastructures'
      @chart = InfrastructureCharts.new

      erb :statistics_layout do
        erb :'statistics/infrastructures'
      end
    end

    get '/statistics/addons' do
      require_relative '../../lib/statistics/charts'
      require_relative '../../lib/statistics/addon_charts'

      @title = 'Platform as a Service | Add-on Statistics'
      @teaser = 'Add-ons'
      @chart = AddonCharts.new

      erb :statistics_layout do
        erb :'statistics/addons'
      end
    end
  end
end