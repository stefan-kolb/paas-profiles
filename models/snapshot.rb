require 'mongoid'

require_relative 'vendor'

class Snapshot
  include Mongoid::Document

  field :revision, type: Date

  embeds_many :vendors
end