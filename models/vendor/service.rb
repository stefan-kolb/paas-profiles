require 'mongoid'

class Service
	include Mongoid::Document
	
	embedded_in :vendor
	
	embeds_many :natives, store_as: "native"
	embeds_many :addons, store_as: "addon"
end

class Native
	include Mongoid::Document
	
	embedded_in :service
	
	field :name, type: String
	field :description, type: String
	field :type, type: String
	field :versions, type: Array
end

class Addon
	include Mongoid::Document
	
	embedded_in :service
	
	field :name, type: String
	field :url, type: String
	field :description, type: String
	field :type, type: String
	# validations
  validates :url, allow_blank: true, format: { with: /http[s]?:\/\/.*/ }
end