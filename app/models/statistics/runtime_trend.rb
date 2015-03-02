require 'mongoid'

module Profiles
  class RuntimeTrend
    include Mongoid::Document

    field :revision, type: Date
    field :language, type: String
    field :count, type: Integer
    field :percentage, type: Float
    # validations
  end
end
