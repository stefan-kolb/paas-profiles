require 'grape-entity'

module Profiles
  class Hosting
    class Entity < Grape::Entity
      expose :public, :private
    end
  end
end