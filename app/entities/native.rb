require 'grape-entity'

module Profiles
  class Native
    class Entity < Grape::Entity
      expose :name, :type, :versions
      expose :description, unless: proc { |e| e.description.blank? }
    end
  end
end
