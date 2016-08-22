require 'grape-entity'

require_relative 'framework'
require_relative 'hosting'
require_relative 'infrastructure'
require_relative 'middleware'
require_relative 'pricing'
require_relative 'quality'
require_relative 'runtime'
require_relative 'scaling'
require_relative 'service'

module Profiles
  class Vendor
    class Entity < Grape::Entity
      expose :name, :revision, :url, :status, :status_since, :type, :extensible, :platform
      expose :vendor_verified, if: :vendor_verified

      expose :hosting, using: Hosting::Entity
      expose :pricings, using: Pricing::Entity
      expose :quality, using: Quality::Entity
      expose :scaling, using: Scaling::Entity

      expose :runtimes, using: Runtime::Entity
      expose :middlewares, using: Middleware::Entity
      expose :frameworks, using: Framework::Entity
      expose :service, using: Service::Entity

      expose :infrastructures, using: Infrastructure::Entity
    end
  end
end
