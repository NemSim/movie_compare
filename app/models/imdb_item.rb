require 'json'
require 'open-uri'

module ImdbItem
	extend ActiveSupport::Concern

	included do
		BASE_URL = "http://www.myapifilms.com/search?"
		attr_accessor :imdb_id, :name
	end


	module ClassMethods
		def logger
			@logger = Logger.new(STDOUT)
		end

		def read_json theUrl
			json = JSON.parse(open(theUrl) {|x| x.read })
			return json
		end
	end
end