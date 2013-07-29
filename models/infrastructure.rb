require 'mongoid'

class Infrastructure
	include Mongoid::Document
	
	field :continent, type: String
	field :country, type: String
	field :region, type: String
	field :provider, type: String
	
	embedded_in :vendor
end