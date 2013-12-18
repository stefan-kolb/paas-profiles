get '/statistics' do
  require_relative '../lib/statistics/charts'
  require_relative '../lib/statistics/infrastructure_charts'
  require_relative '../lib/statistics/scaling_charts'
  require_relative '../lib/statistics/language_charts'
  require_relative '../lib/statistics/service_charts'

  @title = "Platform as a Service | Statistics Dashboard"
  @lang_chart = LanguageCharts.new
  @service_chart = ServiceCharts.new
  @scaling_chart = ScalingCharts.new

  erb :statistics
end

get '/statistics/languages' do
  require_relative '../lib/statistics/charts'
  require_relative '../lib/statistics/language_charts'

  @title = "Platform as a Service | Language Statistics"
  @chart = LanguageCharts.new

  erb :'statistics/languages'
end

get '/statistics/services' do
  require_relative '../lib/statistics/charts'
  require_relative '../lib/statistics/service_charts'

  @title = "Platform as a Service | Native Services Statistics"
  erb :'statistics/services'
end

get '/statistics/status' do
  require_relative '../lib/statistics/charts'
  require_relative '../lib/statistics/status_charts'

  @title = "Platform as a Service | Maturity Statistics"
  erb :'statistics/status'
end

get '/statistics/data' do
  require_relative '../lib/statistics/charts'

  @title = "Platform as a Service | Data Statistics"
  erb :'statistics/data'
end