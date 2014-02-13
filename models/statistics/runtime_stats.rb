require 'mongoid'

class RuntimeStats
  include Mongoid::Document

  # snapshot
  field :revision, type: Date
  # trends
  field :polyglot, type: Integer
  field :language_specific, type: Integer
  field :distinct_languages, type: Integer
  #field :mean_count, type: Float
  #field :median_count, type: Float
  #field :mode_count, type: Float
  #...

  # validations
end