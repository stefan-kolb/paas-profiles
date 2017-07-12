require 'mongoid'

require_relative 'price'

module Pricing
  class Parameter
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    embedded_in :tarif

    # fields
    field :name, type: String
    field :unit, type: String
    field :upper_bound, type: Integer
    field :bundle, type: Integer

    # relations
    embeds_many :price

    # validations
    validates :name, presence: true
    validates :unit, presence: false
    validates :upper_bound, presence: true
    validates :bundle, presence: false
  end
end
