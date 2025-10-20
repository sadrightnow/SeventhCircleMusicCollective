class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_genre, only: [:destroy]

  def index
    @genres = Genre.all
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to genres_path, notice: "Genre was successfully created."
    else
      render :new, alert: "Error creating genre."
    end
  end

  def destroy
    if @genre.destroy
      redirect_to genres_path, notice: "Genre was successfully removed."
    else
      redirect_to genres_path, alert: "Error removing genre."
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

  def set_genre
    @genre = Genre.find(params[:id])
  end
end
