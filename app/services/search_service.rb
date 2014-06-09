class SearchService
	def search query, type
		case type
		when "movie" then search_movie(query)
		when "person" then search_person(query)
		end
	end

	def search_movie query
		return Movie.search_movie query
	end

	def search_person query
		return Person.search_person query
	end
end