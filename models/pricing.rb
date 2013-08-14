require 'mongoid'

class Pricing
	include Mongoid::Document
	
	embedded_in :vendor
	
	field :model, type: String
	field :period, type: String
	# validations
end