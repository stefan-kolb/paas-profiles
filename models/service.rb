require 'mongoid'

class Service
	include Mongoid::Document
	
	embeds_many :natives, store_as: "native"
	embeds_many :addons, store_as: "addon"
	
	embedded_in :vendor
end

class Native
	include Mongoid::Document
	
	field :id, type: String
	field :description, type: String
	field :type, type: String
	field :versions, type: Array
	
	embedded_in :service
end

class Addon
	include Mongoid::Document
	
	field :id, type: String
	field :url, type: String
	field :description, type: String
	field :type, type: String
	
	embedded_in :service
end