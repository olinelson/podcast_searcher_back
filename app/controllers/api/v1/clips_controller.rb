class Api::V1::ClipsController < ApplicationController
    before_action :find_clip, only: [:update, :show, :destroy,]

    

  def index
    @clips = Clip.all
    render json: @clips

  end

  def show
    render json: @clip 
  end

  def create
    if !!params[:audio_file]
      self.upload_audio_file
    end
    if !!params[:video_file]
      self.upload_video_file

    else
      # self.upload_audio_file_from_url
      puts "error"
    end
  end

  def upload_audio_file
    puts "uploading audio file"

    @user = curr_user
    @clip = Clip.new(clip_params)
    @clip.media_type = "audio"
    @clip.author_id = @user.id
    @clip.audio_upload_format = params[:audio_file].original_filename.split('.').last
    @clip.audio_file.attach(params[:audio_file])
    @clip.image.attach(params[:image])
    @clip.processing = false
    @clip.save
     UserClip.create(clip_id: @clip.id, user_id: @user.id)
    @clip.get_gcloud_links_for_audio_clip
  end

  def upload_video_file
    puts "uploading video file"
    @user = curr_user
    @clip = Clip.new(clip_params)
    @clip.media_type = "video"
    @clip.author_id = @user.id
    @clip.audio_upload_format = params[:video_file].original_filename.split('.').last
    @clip.video_file.attach(params[:video_file])
    @clip.image.attach(params[:image])
    @clip.processing = false
    @clip.save
     UserClip.create(clip_id: @clip.id, user_id: @user.id)
    @clip.get_gcloud_links_for_video_clip
  end

  # this is for using with youtube dl
  # def upload_audio_file_from_url
  #   @user = curr_user
  #   @clip = Clip.new
  #   @clip.media_type = "video"
  #   @clip.author_id = @user.id
  #   @clip.audio_upload_format = "mp4"

  #   url = params[:video_url]

  #   @clip.download_youtube_video(url)
  #   @clip.get_gcloud_links_for_video_clip
  #   @clip.processing = false
  #   @clip.save
  #    UserClip.create(clip_id: @clip.id, user_id: @user.id)
  # end

 

  def audio_process 
    @clip = Clip.find(params[:clip_id])
    @clip.processing = true
    @clip.save
    @clip.create_flac_copy
    @clip.process_audio
  end

    


  def destroy
   @clip.delete_with_attachments
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
    params.permit(:name, :image, :tags, :audio_file, :user_email)
  end
end


