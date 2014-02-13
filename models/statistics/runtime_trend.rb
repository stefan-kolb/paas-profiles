require 'mongoid'

class RuntimeTrend
  include Mongoid::Document

  # snapshot
  field :revision, type: Date
  # runtime language
  field :language, type: String
  field :count, type: Integer
  field :percentage, type: Float
  # validations
end