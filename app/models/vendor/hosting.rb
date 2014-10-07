require 'mongoid'

class Hosting
	include Mongoid::Document
	
	embedded_in :vendor
	
	field :public, type: Boolean
	field :private, type: Boolean
	# validations
	validates :public, presence: true
	validates :private, presence: true
end