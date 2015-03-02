require 'mongoid'

require_relative 'vendor/vendor'

module Profiles
  class Snapshot
    include Mongoid::Document

    field :revision, type: Date

    embeds_many :vendors
  end
end
