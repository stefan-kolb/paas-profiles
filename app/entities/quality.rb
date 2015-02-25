require 'grape-entity'

module Profiles
  class Quality
    class Entity < Grape::Entity
      expose :uptime, :compliance
    end
  end
end