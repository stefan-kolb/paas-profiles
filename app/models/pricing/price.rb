require 'mongoid'

module Pricing
  class Price
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    embedded_in :parameter

    # fields
    field :minimum, type: Integer
    field :maximum, type: Integer
    field :pricing_unit, type: Integer
    field :price_per_unit, type: Float

    # validations
    validates :minimum, presence: false
    validates :maximum, presence: false
    validates :pricing_unit, presence: false
    validates :price_per_unit, presence: true
  end
end
