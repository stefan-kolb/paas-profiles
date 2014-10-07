require 'mongoid'

class Middleware
  include Mongoid::Document

  embedded_in :vendor

  field :name, type: String
  field :runtime, type: String
  field :versions, type: Array
  # validations
  validates :name, presence: true
end