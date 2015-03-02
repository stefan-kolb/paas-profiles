require 'mongoid'

module Profiles
  class Scaling
    include Mongoid::Document

    embedded_in :vendor

    field :vertical, type: Boolean
    field :horizontal, type: Boolean
    field :auto, type: Boolean
    # validations
    validates :vertical, presence: true
    validates :horizontal, presence: true
    validates :auto, presence: true
  end
end
