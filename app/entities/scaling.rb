require 'grape-entity'

module Profiles
  class Scaling
    class Entity < Grape::Entity
      expose :horizontal, :vertical, :auto
    end
  end
end