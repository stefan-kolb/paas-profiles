require 'mongoid'

class Quality
	include Mongoid::Document
	
	embedded_in :vendor
	
	field :uptime, type: Float
  field :compliance, type: Array
	# validations
end