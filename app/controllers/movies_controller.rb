class MoviesController < ApplicationController  
  before_filter :collect_ratings
  attr_accessor :hilite_headers 
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @hilite_headers = {"title" => :common, "release_date" => :common}
    params.has_key?(:ratings) ? rates = params[:ratings].keys : rates = "*"
    if rates.class == Array then rates.each {|x| @checked_checkboxes[x] = true} end

    if params.has_key?(:sort_by)
      header = params[:sort_by]
      @hilite_headers[header] = :hilite
      session[:sorted_by] = header
      @movies = Movie.find(:all, :order => header, :conditions => {:rating => rates})
    else
      @movies = Movie.find(:all, :conditions => {:rating => rates})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
    
  private
    def collect_ratings
      @all_ratings = Movie.select(:rating).map(&:rating).uniq
      @checked_checkboxes = Hash.new
      @all_ratings.each {|x| @checked_checkboxes[x] = false}
    end  
end
