class VideoThumbnailWorker
  include Sidekiq::Worker

   require 'streamio-ffmpeg'

  def perform(clip_id)
    clip = Clip.find(clip_id)

    movie = FFMPEG::Movie.new(clip.gcloud_media_link)
    screenshot = movie.screenshot("#{clip.id}_screenshot.jpg")
    clip.image.attach(io: File.open("#{clip.id}_screenshot.jpg"), filename: "#{clip.id}_screenshot.jpg")
    clip.gcloud_image_link = "https://storage.googleapis.com/bucket-of-doom/#{clip.image.key}"
    clip.save
    File.delete("#{clip.id}_screenshot.jpg")
  end
end
