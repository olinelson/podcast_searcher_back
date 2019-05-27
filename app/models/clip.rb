class Clip < ApplicationRecord
    require "google/cloud/speech"
    require "google/cloud/storage"
    # require 'youtube-dl.rb'
    require 'streamio-ffmpeg'

    has_one_attached :audio_file
    has_one_attached :image
    has_one_attached :video_file
    has_many :user_clips
    has_many :users, through: :user_clips
    has_many :cliptags
    has_many :tags, through: :cliptags
    belongs_to :author, foreign_key: 'author_id', class_name: 'User' 


    def send_clip_done_email
    # NotificationMailer.clip_done_email(self).deliver
    # in order to work with delayed job had to change this to:
    # NotificationMailer.delay.clip_done_email(self)
    puts "pretending to send email"
    end

    def get_gcloud_links_for_audio_clip
        self.gcloud_service_link = "gs://bucket-of-doom/#{self.audio_file.key}"
        self.gcloud_media_link = "https://storage.googleapis.com/bucket-of-doom/#{self.audio_file.key}"
        self.gcloud_image_link = "https://storage.googleapis.com/bucket-of-doom/#{self.image.key}"
        self.save
    end

     def get_gcloud_links_for_video_clip
        self.gcloud_service_link = "gs://bucket-of-doom/#{self.video_file.key}"
        self.gcloud_media_link = "https://storage.googleapis.com/bucket-of-doom/#{self.video_file.key}"
        # self.gcloud_image_link = "https://storage.googleapis.com/bucket-of-doom/#{self.image.key}"
        self.save
      end

      # def get_gcloud_links_for_youtube_clip
      #   self.gcloud_service_link = "gs://bucket-of-doom/#{self.video_file.key}"
      #   self.gcloud_media_link = "https://storage.googleapis.com/bucket-of-doom/#{self.video_file.key}"
      #   self.save
      # end


    def delete_with_attachments
      self.audio_file.purge
      self.image.purge
      self.destroy
    end
   


   def process_audio audio_file_path: nil
    TranscriberWorker.perform_async(self.id)
   end 



  def create_flac_copy
    ConverterWorker.perform_async(self.id)
  end

# uses url as uuid for temp file
# def download_youtube_video(url)

#   uuid = url.split('/').last
#   youtube = YoutubeDL.download url, output: "tmp/downloads/#{uuid}.mp4"
#   self.name = youtube.information[:fulltitle]
#   self.video_file.attach(io: File.open("tmp/downloads/#{uuid}.mp4"), filename: "#{url}.mp4")
#   File.delete("tmp/downloads/#{uuid}.mp4") if File.exist?("tmp/downloads/#{uuid}.mp4")
#   downloaded_image = open(youtube.information[:thumbnails].first[:url])
#   self.image.attach(io: downloaded_image  , filename: "thumbnail.jpg")
#   self.save
# end

def generate_video_thumbnail
  VideoThumbnailWorker.perform_async(self.id)
end


 
# for use with delayed action
# this seems like very dumb syntax but commas were not working??
# handle_asynchronously :send_clip_done_email 
# handle_asynchronously :delete_with_attachments 
# handle_asynchronously :process_audio 
# handle_asynchronously :create_flac_copy
# handle_asynchronously :generate_video_thumbnail


# handle_asynchronously :download_youtube_video 

# :delete_with_attachments 
# :create_flac_copy, :process_audio

end #end of Clip Class

# comment agains