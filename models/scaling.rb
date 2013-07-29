require 'mongoid'

class Scaling
	include Mongoid::Document
	
	field :vertical, type: Boolean
	field :horizontal, type: Boolean
	field :auto, type: Boolean
	
	embedded_in :vendor
end