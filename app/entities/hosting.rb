require 'grape-entity'

module Profiles
  class Hosting
    class Entity < Grape::Entity
      expose :public, :private, :vps
    end
  end
end
