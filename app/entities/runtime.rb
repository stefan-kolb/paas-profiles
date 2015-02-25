require 'grape-entity'

module Profiles
  class Runtime
    class Entity < Grape::Entity
      expose :language, :versions
    end
  end
end