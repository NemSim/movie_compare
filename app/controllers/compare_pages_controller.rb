class ComparePagesController < ApplicationController
  before_filter :load_data_service

  def home
  end

  def view
  	if !params[:p].nil?
  		@actor = @data_service.get_actor params[:p]
  		render 'display/actor'
  	else
  		@movie = @data_service.get_movie params[:m]
  		render 'display/movie'
  	end
  end

  def compare
  end

  def search
  	if params[:type][:search_type] == "movie"
  		@movie = @data_service.search_movie(params[:query])
  		render 'display/movie'
  	else
  		@actor = @data_service.search_actor(params[:query])
  		render 'display/actor'
  	end  		
  end

  def load_data_service(service = DataService.new)
  	@data_service ||= service
  end
end
