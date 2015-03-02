require 'mongoid'

module Profiles
  class Service
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    embedded_in :vendor

    embeds_many :natives, store_as: 'native'
    embeds_many :addons, store_as: 'addon'
    # validations
    validates :natives, presence: true, allow_blank: true
    validates :natives, presence: true, allow_blank: true
  end

  class Native
    include Mongoid::Document

    embedded_in :service

    field :name, type: String
    field :description, type: String
    field :type, type: String
    field :versions, type: Array
    # validations
    validates :name, presence: true
  end

  class Addon
    include Mongoid::Document

    embedded_in :service

    field :name, type: String
    field :url, type: String
    field :description, type: String
    field :type, type: String
    # validations
    validates :name, presence: true
    validates :url, allow_blank: true, format: { with: %r{http[s]?://.*} }
  end
end
