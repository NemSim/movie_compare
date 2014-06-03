require 'json'
require 'open-uri'

class DataService

	def initialize
		@base_url = "http://www.myapifilms.com/search?"
		@logger = Logger.new(STDOUT)
	end

	def search_movie query
		movieTitle = query.gsub(' ', '+')
		queryUrl = "#{@base_url}title=#{movieTitle}&actors=F"
		json = read_json queryUrl
		return parse_movie_json json[0]
	end

	def search_actor query
		actorName = query.gsub(' ', '+')
		queryUrl = "#{@base_url}name=#{query.gsub(' ', '+')}&filmography=1&bornDied=1"
		json = read_json queryUrl
		return parse_actor_json json[0]
	end

	def get_actor imdbId
		queryUrl = "#{@base_url}idName=#{imdbId}&filmography=1&bornDied=1"
		json = read_json queryUrl

		return parse_actor_json json
	end

	def get_movie imdbId
		queryUrl = "#{@base_url}idIMDB=#{imdbId}&actors=S"
		json = read_json queryUrl

		return parse_movie_json json
	end

	def read_json theUrl
		json = JSON.parse(open(theUrl) {|x| x.read })
		return json
	end

	def parse_actor_json json
		retVal = {}
		retVal[:name] = json['name']
		retVal[:imdb_id] = json['idIMDB']
		retVal[:photo_url] = json['urlPhoto']
		retVal[:bio] = json['bio']
		retVal[:birth_name] = json['birthName']
		retVal[:birth_date] = json['dateOfBirth']
		retVal[:filmography] = parse_filmography_json json['filmographies']

		return retVal
	end

	def parse_filmography_json json
		retVal = []

		json.each { |filmGroup|
			filmGroup['filmography'].each { |item|
				filmItem = {}

				filmItem[:imdb_id] = item['IMDBId']
				filmItem[:title] = item['title']
				filmItem[:year] = item['year']
				filmItem[:role] = filmGroup['section']

				retVal.push filmItem
			}
		}

		# filmography item


		return retVal
	end

	def parse_movie_json json
		retVal = {}
		retVal[:title] = json['title']
		retVal[:release_date] = json['release_date']
		retVal[:plot] = json['plot']
		retVal[:poster_url] = json['urlPoster']
		retVal[:imdb_id] = json['idIMDB']
		retVal[:year] = json['year']
		retVal[:cast] = parse_movie_cast json

		return retVal
	end

	def parse_movie_cast json
		retVal = { actors: [], directors: [], writers: [] }

		json['actors'].each { |actorJson|
			actor = parse_cast_actor actorJson
			retVal[:actors].push actor
		}

		json['directors'].each { |directorJson| 
			director = parse_cast_member directorJson
			retVal[:directors].push director
		}

		json['writers'].each { |writerJson|
			writer = parse_cast_member writerJson
			retVal[:writers].push writer
		}

		return retVal
	end

	def parse_cast_actor json
		retVal = {}
		retVal[:name] = json['actorName']
		retVal[:imdb_id] = json['actorId']
		retVal[:photo] = json['urlPhoto']
		puts retVal
		return retVal
	end

	def parse_cast_member json
		retVal = {}
		retVal[:name] = json['name']
		retVal[:imdb_id] = json['nameId']
		return retVal
	end
end