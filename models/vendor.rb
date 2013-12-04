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
	field :vendor_verified, type: Date
	field :url, type: String
	field :status, type: String
	field :status_since, type: Date
	field :type, type: String
	field :extensible, type: Boolean
	field :hosting, type: Array
	field :compliance, type: Array
	# relations
	embeds_many :pricing, store_as: "pricing"
	embeds_one :scaling
	embeds_many :runtimes
	embeds_many :middlewares, store_as: "middleware"
	embeds_many :frameworks
	embeds_one :service, store_as: "services"
	embeds_many :infrastructures
	# validations
	validates :name, presence: true
	validates :revision, presence: true # todo format
	# validates :vendor_verified, presence: true # todo optional?
	validates :url, presence: true, format: { with: /http[s]?:\/\/.*/ }
	validates :status, presence: true, inclusion: { in: [ "beta", "production", "eol" ] } # todo values
	# validates :status_since, presence: true # todo format, optional?
	validates :type, presence: true # todo optional?
	validates :extendable, presence: true
	# todo custom validator validates :hosting, presence: true, inclusion: { in: [ "public", "private" ] } # todo values
	# validates :pricing, presence: true
	validates :scaling, presence: true
	validates :runtimes, presence: true
	# middleware?, frameworks?, services?
	# validates :infrastructures, presence: true
	# validates :services, presence: true
end