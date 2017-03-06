require 'grape-entity'

module Profiles
  class Hosting
    class Entity < Grape::Entity
      expose :public, :private, :virtual_private
    end
  end
end
