class Person
	include ImdbItem

	attr_accessor :photo_url, :bio, :photo_url, :birth_name, :birth_date, :filmography

	def initialize(imdb_id, name, bio, photo_url, birth_name, birth_date)
		@imdb_id = imdb_id
		@name = name
		@bio = bio
		@photo_url = photo_url
		@birth_name = birth_name
		@birth_date = birth_date
	end

	def self.search_person query
		query_url = "#{BASE_URL}name=#{query.gsub(' ', '+')}&filmography=1&bornDied=1"
		json = read_json query_url
		return parse_person json[0]
	end

	def self.parse_person json
		#retVal[:filmography] = parse_filmography_json json['filmographies']

		retVal = Person.new(json['idIMDB'], json['name'], json['bio'], json['urlPhoto'], json['birthName'], json['dateOfBirth'])

		return retVal
	end
end