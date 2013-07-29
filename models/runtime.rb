require 'mongoid'

class Runtime
	include Mongoid::Document
	
	field :language, type: String
	field :versions, type: Array
	
	embedded_in :vendor
end