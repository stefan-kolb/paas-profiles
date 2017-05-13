require 'mongoid'

module Pricing
  class FormParameter
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    # fields
    field :name, type: String
    field :unit, type: String
    # field :upper_bound, type: Integer
    # field :bundle, type: Integer

    # validations
    validates :name, presence: true
    validates :unit, presence: true
    # validates :upper_bound, presence: false
    # validates :bundle, presence: false
  end
end
