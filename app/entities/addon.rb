require 'grape-entity'

module Profiles
  class Addon
    class Entity < Grape::Entity
      expose :name, :url, :type
      expose :description, unless: proc { |e| e.description.blank? }
    end
  end
end
