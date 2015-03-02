$LOAD_PATH.unshift('lib')

require 'require_all'

# controllers
require_relative 'base'
require_relative 'app/controllers/main'
require_relative 'app/controllers/geo'
require_relative 'app/controllers/statistics'

# models
require_all 'app/models'

Mongoid.load!('config/mongoid.yml')

module Profiles
  class Web < Base
    # controllers
    use Main
    use StatisticsController
    use Geo
  end
end