class ComparePagesController < ApplicationController
  before_filter :load_data_service, :load_logger

  def home
  end

  def view
  	if !params[:p].nil?
  		# viewing a person
  		@actor = @data_service.get_actor params[:p]
  		@current_id = @actor[:imdb_id]
  		render 'display/actor'
  	else
  		@movie = @data_service.get_movie params[:m]
  		@current_id = @movie[:imdb_id]
  		render 'display/movie'
  	end
  end

  def compare_cast cast1, cast2
  	fullCast1 = get_full_cast cast1

  	logger.debug "Cast 1"
  	logger.debug fullCast1.size

  	fullCast2 = get_full_cast cast2

  	logger.debug "Cast 2"
  	logger.debug fullCast2.size

  	overlapCast = fullCast1 & fullCast2
  	logger.debug "Overlapping cast"
  	logger.debug overlapCast.size

  	return overlapCast
  end

  def get_full_cast castGroup
  	fullCast = []

  	castGroup.keys.each { |role|
  		castGroup[role].each { |person|
  			if !fullCast.include? person
  				fullCast.push person
  			end
  		}
  	}

  	fullCast
  end

  def is_actor_present actor, movie
  	movie_id = movie[:imdb_id]
  	retVal = {}
  	retVal[:value] = false

  	actor[:filmography].each { |film|
  		logger.debug "Comparing #{film[:imdb_id]} and #{movie_id}"
  		if film[:imdb_id] == movie_id
  			retVal[:value] = true
  			logger.debug "THE SAME!!!!!!!!!!!!!!!!"
  			break
  		end
  	}

  	return retVal
  end


  def search
  	if params[:type][:search_type] == "movie"
  		
  		@movie = @data_service.search_movie(params[:query])
  		if !params[:compared_id].nil?
  			# compare two things
  			logger.debug "Comparing movie"

  			if params[:compared_id].start_with?('tt')
  				logger.debug " to a movie"
  				# comparing to a movie
  				@movie1 = @data_service.get_movie params[:compared_id]
  				@movie2 = @movie

  				# get cast from both movies and see if they intersect
  				@intersecting_cast = compare_cast @movie1[:cast], @movie[:cast]
  				render 'compare_pages/compare'
  			else
  				logger.debug " to an actor"
  				# comparing to an actor
  				@actor = @data_service.get_actor params[:compared_id]

  				# check if actor is in this movie
  				@actor_present = is_actor_present @actor, @movie
  				render 'compare_pages/compare'
  			end
  		else
  			logger.debug "Finding movie"
  			@current_type = 'm'
  			@current_id = @movie[:imdb_id]
  			render 'display/movie'
  		end
  	else
  		@actor = @data_service.search_actor(params[:query])
  		
  		if !params[:compared_id].nil?
  			# compare two things
  			logger.debug "Comparing actor"

  			if params[:compared_id].start_with?('tt')
  				# compare to a movie
  				logger.debug " to a movie"
  				@movie = @data_service.get_movie params[:compared_id]

  				@actor_present = is_actor_present @actor, @movie
  				render 'compare_pages/compare'
  			else
  				# compare to an actor
  				logger.debug " to an actor"
  				@intersecting_movies = []
  				render 'compare_pages/compare'
  			end
  		else
  			logger.debug "Finding actor"
  			@current_type = 'p'
  			@current_id = @actor[:imdb_id]
  			render 'display/actor'
  		end
  	end  		
  end

  def load_data_service(service = DataService.new)
  	@data_service ||= service
  end

  def load_logger(logger = Logger.new(STDOUT))
  	@logger ||= logger
  end
end
