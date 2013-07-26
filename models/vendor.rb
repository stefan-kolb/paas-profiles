require 'mongoid'

class Vendor
	include Mongoid::Document
	
	# fields
	field :name, type: String
	field :revision, type: DateTime
	field :vendor_verified, type: Boolean
	field :url, type: String
	field :status, type: String
	field :status_since, type: Date
	field :type, type: String
	field :extendable, type: Boolean
	field :hosting, type: Array
	field :compliance, type: Array
	# objects
	embeds_one :pricing
	embeds_one :scaling
	embeds_many :runtimes
	embeds_many :middlewares, store_as: "middleware"
	embeds_many :frameworks
	embeds_one :service, store_as: "services"
	embeds_many :infrastructures
	
end

class Pricing
	include Mongoid::Document
	
	field :model, type: String
	field :period, type: String
	
	embedded_in :vendor
end

class Scaling
	include Mongoid::Document
	
	field :vertical, type: Boolean
	field :horizontal, type: Boolean
	field :auto, type: Boolean
	
	embedded_in :vendor
end

class Runtime
	include Mongoid::Document
	
	field :language, type: String
	field :versions, type: Array
	
	embedded_in :vendor
end

class Middleware
	include Mongoid::Document
	
	field :id, type: String
	field :runtime, type: String
	field :versions, type: Array
	
	embedded_in :vendor
end

class Framework
	include Mongoid::Document
	
	field :id, type: String
	field :runtime, type: String
	field :versions, type: Array
	
	embedded_in :vendor
end

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

class Infrastructure
	include Mongoid::Document
	
	field :continent, type: String
	field :country, type: String
	field :region, type: String
	field :provider, type: String
	
	embedded_in :vendor
end