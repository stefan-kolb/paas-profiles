require 'mongoid'

require_relative 'statistics/runtime_trend'

# trends?
class Statistics
  include Mongoid::Document

  field :revision, type: String
  field :polyglot_count, type: Integer
  field :lspecific_count, type: Integer
  field :language_count, type: Integer
  field :distinct_count, type: Integer

  has_many :runtime_trends
  # validations
  validates :revision, presence: true
end