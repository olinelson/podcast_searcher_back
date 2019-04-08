class Api::V1::PodcastsController < ApplicationController
    before_action :find_podcast, only: [:update, :show, :destroy]
  def index
    @podcasts = Podcast.all
    render json: @podcasts

  end

  def show
    render json: @podcast
   
  end

  def create
   
    @podcast = podcast.create(podcast_params)
   
end
    


  def destroy
    @podcast.delete
  end

  def update
    @podcast.update(podcast_params)
    if @podcast.save
      render json: @podcast, status: :accepted
    else
      render json: { errors: @podcast.errors.full_messages }, status: :unprocessible_entity
    end
  end


  private

  def find_podcast
    @podcast = Podcast.find(params[:id])
  end

  def podcast_params
    params.permit(:name, :audio_file)
  end
end
