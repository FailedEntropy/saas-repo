class MoviesController < ApplicationController  
  before_filter :collect_ratings
  attr_accessor :hilite_headers 
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @headers_class = {"title" => :common, "release_date" => :common}
    @sort_by_header = params[:sort_by]
    params.has_key?(:ratings) ? @filter_by = params[:ratings].each_value do |x| x = true end : @filter_by = Hash.new
    
    if @sort_by_header != nil then session[:sort_by_header] = @sort_by_header
    else @sort_by_header = session[:sort_by_header] end
    
    if @filter_by.empty?  then if session[:filter_by] != nil then @filter_by = session[:filter_by] end
    else session[:filter_by] = @filter_by end
  
    @headers_class[@sort_by_header] = :hilite
    @movies = Movie.find(:all, :order => @sort_by_header, :conditions => {:rating => @filter_by.keys})
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
    end  
end
