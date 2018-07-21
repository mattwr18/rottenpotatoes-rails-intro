class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    params_session_persistency
    set_movies
    sort_highlighting
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def params_session_persistency
    @sort = params[:sort]
    session[:sort] = @sort if @sort
    @ratings = params[:ratings]
    session[:ratings] = @ratings if @ratings
  end

  def set_movies
    @movies = if session[:sort] && session[:ratings]
                @selected_ratings = session[:ratings]
                Movie.where(rating: @selected_ratings.keys).order(session[:sort])
              elsif @ratings
                @selected_ratings = @ratings
                Movie.where(rating: @selected_ratings.keys)
              else
                @selected_ratings = @all_ratings
                Movie.all.order(@sort)
              end
  end

  def sort_highlighting
    @title_header = 'hilite' if @sort == 'title' || session[:sort] == 'title'
    @release_date_header = 'hilite' if @sort == 'release_date' || session[:sort] == 'release_date'
  end
end
