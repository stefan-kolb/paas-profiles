require 'mongoid'

require_relative 'pricing'
require_relative 'scaling'
require_relative 'runtime'
require_relative 'middleware'
require_relative 'framework'
require_relative 'service'
require_relative 'infrastructure'

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