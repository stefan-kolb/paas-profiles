require 'grape-entity'

module Profiles
  class Pricing
    class Entity < Grape::Entity
      expose :model, :period
    end
  end
end