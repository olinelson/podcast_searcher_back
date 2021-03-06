class Api::V1::ClipsController < ApplicationController
    before_action :find_clip, only: [:update, :show, :destroy,]

  def index
    @clips = Clip.all
    json_string = Api::V1::ClipSerializer.new(@clips).serialized_json
    render json: json_string

  end

  def show
    json_string = Api::V1::ClipSerializer.new(@clip).serialized_json
    render json: json_string
  end

  def create
    if !!params[:audio_file]
      self.upload_audio_file
    end
    if !!params[:video_file]
      self.upload_video_file

    else
      # self.upload_youtube_video
      puts "error"

    end
  end

  def upload_audio_file
    puts "uploading audio file step 1"

    @user = curr_user
    @clip = Clip.new(clip_params)
    @clip.media_type = "audio"
    @clip.author_id = @user.id
    @clip.audio_upload_format = params[:audio_file].original_filename.split('.').last
    puts "attaching audio file"
    @clip.save
    @clip.audio_file.attach(params[:audio_file])
    # @clip.image.attach(params[:image])
    @clip.processing = false
    @clip.save
    @clip.get_gcloud_links_for_audio_clip
    UserClip.create(clip_id: @clip.id, user_id: @user.id)
  end

  def upload_video_file

    puts "uploading video file"
    @user = curr_user
    @clip = Clip.new(clip_params)
    @clip.media_type = "video"
    @clip.author_id = @user.id
    @clip.audio_upload_format = params[:video_file].original_filename.split('.').last
    @clip.video_file.attach(params[:video_file])
    @clip.processing = false
    @clip.save
    UserClip.create(clip_id: @clip.id, user_id: @user.id)
    @clip.generate_video_thumbnail
    @clip.get_gcloud_links_for_video_clip
  end

  # this is for using with youtube dl
  # def upload_youtube_video

  #   @user = curr_user
  #   @clip = Clip.new
  #   @clip.media_type = "video"
  #   @clip.author_id = @user.id
  #   @clip.audio_upload_format = "mp4"

  #   url = params[:video_url]

  #   @clip.save
  #   byebug
  #   @clip.download_youtube_video(url)
  #   byebug
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


