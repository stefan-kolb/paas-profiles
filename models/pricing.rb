require 'mongoid'

class Pricing
	include Mongoid::Document
	
	field :model, type: String
	field :period, type: String
	
	embedded_in :vendor
end