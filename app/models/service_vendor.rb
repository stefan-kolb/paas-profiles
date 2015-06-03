module Profiles
  class ServiceVendor
    include Mongoid::Document

    field :key, type: String
    field :name, type: String
    field :url, type: String
    field :twitter, type: String
    field :description, type: String
    field :type, type: String
    # validations
    validates :name, presence: true
    validates :url, allow_blank: true, format: { with: %r{http[s]?://.*} }
    validates :description, allow_blank: true, format: { with: /\A.{,140}\z/ }
  end
end
