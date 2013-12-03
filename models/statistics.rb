require 'mongoid'

require_relative 'statistics/runtime_trend'

# trends?
class Statistics
  include Mongoid::Document

  field :revision, type: String

  has_many :runtime_trends
  # validations
  validates :revision, presence: true
end