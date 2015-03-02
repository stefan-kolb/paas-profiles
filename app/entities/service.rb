require 'grape-entity'

require_relative 'addon'
require_relative 'native'

module Profiles
  class Service
    class Entity < Grape::Entity
      expose :natives, using: Native::Entity
      expose :addons, using: Addon::Entity
    end
  end
end
