require 'grape-entity'

module Profiles
  class Addon
    class Entity < Grape::Entity
      expose :name, :url, :type
    end
  end
end