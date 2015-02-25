require 'grape-entity'

module Profiles
  class Middleware
    class Entity < Grape::Entity
      expose :name, :runtime, :versions
    end
  end
end