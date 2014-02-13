require 'mongoid'

class DataTrend
  include Mongoid::Document

  field :revision, type: Date
  field :active_count, type: Integer
  field :eol_count, type: Integer
  # validations
end