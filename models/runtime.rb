require 'mongoid'

class Runtime
	include Mongoid::Document
	
	embedded_in :vendor
	
	field :language, type: String
	field :versions, type: Array
	# validations
	validates :language, presence: true
end