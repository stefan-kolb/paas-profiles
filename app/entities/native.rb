require 'grape-entity'

module Profiles
  class Native
    class Entity < Grape::Entity
      expose :name, :type, :versions
    end
  end
end
