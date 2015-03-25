$LOAD_PATH.unshift('lib')

require 'require_all'

require_relative 'app/base'
# controllers
require_relative 'app/controllers/main'
require_relative 'app/controllers/statistics'
# models
require_all 'app/models'

module Profiles
  class Web < Base
    use Main
    use StatisticsController
  end
end
