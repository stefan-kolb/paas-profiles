require 'mongoid'

require_relative 'statistics/runtime_trend'

# trends?
module Profiles
  class Statistics
    include Mongoid::Document

    field :revision, type: Date
    field :polyglot_count, type: Integer
    field :lspecific_count, type: Integer
    field :language_count, type: Integer
    field :mean_lang_count, type: Float
    field :vendor_count, type: Integer

    has_many :runtime_trends
    # validations
    validates :revision, presence: true
  end
end
