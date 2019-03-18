class Api::V1::ClipsController < ApplicationController
    before_action :find_clip, only: [:update, :show, :destroy]


  def index
    @clips = Clip.all
    render json: @clips

  end

  def show
    render json: @clip #,  methods: :audio_file_url
   
  end

  def create
    
   
    @clip = Clip.new(clip_params)
    @clip.audio_file.attach(params[:audio_file])
    @clip.get_gcloud_links

    @clip.save
        

   
    
   
  end

    


  def destroy
    @clip.delete
  end

  def update
    @clip.update(clip_params)
    if @clip.save
      render json: @clip, status: :accepted
    else
      render json: { errors: @clip.errors.full_messages }, status: :unprocessible_entity
    end
  end


  private

  def find_clip
    @clip = Clip.find(params[:id])
  end

  def clip_params
    params.permit(:name,)
  end
end
