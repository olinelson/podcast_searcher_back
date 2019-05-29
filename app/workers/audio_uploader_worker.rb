class AudioUploaderWorker
  include Sidekiq::Worker

  def perform(clip_id, params, user_id)
    user = User.find(user_id)
    clip = Clip.find(clip_id)
    clip.audio_file.attach(params[:audio_file])
    clip.image.attach(params[:image])
  
    
  end
end
