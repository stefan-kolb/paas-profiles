module Profiles
  module Logs
    class Query
      include Mongoid::Document
      include Mongoid::Timestamps::Created

      field :ip, type: String
      field :selector, type: String
      field :size, type: Integer
    end
  end
end