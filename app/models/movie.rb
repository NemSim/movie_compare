class Movie
	include ImdbItem

	attr_accessor :plot, :poster_url, :year, :cast

	def initialize(imdb_id, name, plot, poster_url, year)
		@imdb_id = imdb_id
		@name = name
		@plot = plot
		@poster_url = poster_url
		@year = year
	end

	def self.search_movie query
		query_url = "#{BASE_URL}title=#{query.gsub(' ', '+')}&actors=F"
		json = read_json query_url
		return parse_movie json[0]
	end

	def self.parse_movie json
		#retVal[:cast] = parse_movie_cast json

		retVal = Movie.new(json['idIMDB'], json['title'], json['plot'], json['urlPoster'], json['year'])

		return retVal
	end
end