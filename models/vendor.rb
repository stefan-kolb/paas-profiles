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
	embeds_one :pricing,
	embeds_one :scaling,
	embeds_many :runtimes,
	embeds_many :middleware,
	embeds_many :frameworks,
	embeds_many :services,
	embeds_many :infrastructures,
	
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
	
	
end

class Middleware
	include Mongoid::Document
	
	
end

class Framework
	include Mongoid::Document
	
	
end

class Service
	include Mongoid::Document
	
	
end

class Infrastructure
	include Mongoid::Document
	
	
end

