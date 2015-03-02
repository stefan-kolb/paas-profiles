require 'grape-entity'

module Profiles
  class Infrastructure
    class Entity < Grape::Entity
      expose :continent
      expose :country
      expose :region
      expose :provider
    end
  end
end
