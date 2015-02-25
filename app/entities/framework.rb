require 'grape-entity'

module Profiles
  class Framework
    class Entity < Grape::Entity
      expose :name, :runtime, :versions
    end
  end
end