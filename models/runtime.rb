require 'mongoid'

class Runtime
  include Mongoid::Document

  field :name, type: String
  field :revision, type: DateTime
  field :version, type: String
  field :module, type: String
  # validation
  #validates :url, presence: true, format: { with: /http[s]?:\/\/.*/ }
  #validates :association, presence: true
  #validates :source, presence: true, format: { with: /http[s]?:\/\/.*/ }
  #validates :gender, presence: true, inclusion: { in: [ "M", "F", "X", "Y" ] }
end