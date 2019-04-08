class Clip < ApplicationRecord
    require "google/cloud/speech"
    require "google/cloud/storage"
    require 'youtube-dl.rb'


  

    has_one_attached :audio_file
    has_one_attached :image
    has_one_attached :video_file
    has_many :user_clips
    has_many :users, through: :user_clips
    has_many :cliptags
    has_many :tags, through: :cliptags
    belongs_to :author, foreign_key: 'author_id', class_name: 'User' 


    def send_clip_done_email
    NotificationMailer.clip_done_email(self).deliver
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
        self.gcloud_image_link = "https://storage.googleapis.com/bucket-of-doom/#{self.image.key}"
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

# [START speech_transcribe_async]
  self.processing = true
  self.save
  storage_path = self.gcloud_service_link + "processed.flac"

  

  speech = Google::Cloud::Speech.new 

  # [START speech_ruby_migration_async_response]
  # [START speech_ruby_migration_async_request]
  
  config     = { encoding:          :FLAC,
                 sample_rate_hertz: 44100,
                 language_code:     "en-US",
                enable_word_time_offsets: true

                
            }
  audio      = { uri: storage_path }

  operation = speech.long_running_recognize config, audio

  puts "Operation started"

  operation.wait_until_done!

  raise operation.results.message if operation.error?

  results = operation.response.results
  
  puts "defining results"
alternatives = results.first.alternatives
wordsArray = []
puts "iterating through results"
results.each do |r|
    r.alternatives.each do |alternative|
    self.transcript = "#{self.transcript} #{alternative.transcript}"

  alternative.words.each do |word|
   start_time = word.start_time.seconds + word.start_time.nanos/1000000000.0
    end_time   = word.end_time.seconds + word.end_time.nanos/1000000000.0

    new_word = { word:word.word, start_time: start_time, end_time: end_time}.to_json
    wordsArray.push(new_word)
  end
  self.words = wordsArray
 
end
end
self.processing = false
 self.save
 self.send_clip_done_email
end #end



require 'rest-client'

def create_flac_copy
  inputFormat = self.audio_upload_format

  originalFileName = self.gcloud_media_link.split('/').last
  newFileName = originalFileName + "processed.flac"

  url = 'https://api.cloudconvert.com/convert?apikey=' +
           ENV["CLOUD_CONVERT_KEY"] +
          '&inputformat=' + inputFormat + 
          '&outputformat=flac&input[googlecloud][projectid]=' + ENV["PROJECT_ID"] + 
          '&input[googlecloud][bucket]=bucket-of-doom&input[googlecloud][credentials][type]=service_account&input[googlecloud][credentials][project_id]=' + ENV["PROJECT_ID"] +
          '&input[googlecloud][credentials][private_key_id]=' + ENV["PRIVATE_KEY_ID"] + 
          '&input[googlecloud][credentials][private_key]=' + ENV["PRIVATE_KEY"] + 
          '&input[googlecloud][credentials][client_email]=' + ENV["CLIENT_EMAIL"] + 
          '&input[googlecloud][credentials][client_id]=' + ENV["CLIENT_ID"] + 
          '&input[googlecloud][credentials][auth_uri]=' + ENV["AUTH_URI"] + 
          '&input[googlecloud][credentials][token_uri]=' + ENV["TOKEN_URI"] + 
          '&input[googlecloud][credentials][auth_provider_x509_cert_url]=' + ENV["AUTH_PROVIDER"] +
          '&input[googlecloud][credentials][client_x509_cert_url]='+ ENV["CLIENT_CERT"] +
          '&file=' + originalFileName + 
          '&filename=' + originalFileName + "." + inputFormat +
          '&converteroptions[audio_codec]=FLAC&converteroptions[audio_bitrate]=128&converteroptions[audio_channels]=1&converteroptions[audio_frequency]=44100&converteroptions[strip_metatags]=false&output[googlecloud][projectid]=' + ENV["PROJECT_ID"] + 
          '&output[googlecloud][bucket]=bucket-of-doom&output[googlecloud][credentials][type]=service_account&output[googlecloud][credentials][project_id]=' + ENV["PROJECT_ID"] +
          '&output[googlecloud][credentials][private_key_id]=' + ENV["PRIVATE_KEY_ID"] + 
          '&output[googlecloud][credentials][private_key]=' + ENV["PRIVATE_KEY"] + 
          '&output[googlecloud][credentials][client_email]=' + ENV["CLIENT_EMAIL"] + 
          '&output[googlecloud][credentials][auth_uri]=' + ENV["AUTH_URI"] + 
          '&output[googlecloud][credentials][token_uri]=' + ENV["TOKEN_URI"] + 
          '&output[googlecloud][credentials][auth_provider_x509_cert_url]=' + ENV["AUTH_PROVIDER"] +
          '&output[googlecloud][credentials][client_x509_cert_url]='+ ENV["CLIENT_CERT"] +
          '&output[googlecloud][path]='+ newFileName + '&wait=true&download=false'
  RestClient.get url
  # puts url
end

# uses url as uuid for temp file
def download_youtube_video(url)
uuid = url.split('/').last
youtube = YoutubeDL.download url, output: "tmp/downloads/#{uuid}.mp4"
self.name = youtube.information[:fulltitle]
self.video_file.attach(io: File.open("tmp/downloads/#{uuid}.mp4"), filename: "#{url}.mp4")
File.delete("tmp/downloads/#{uuid}.mp4") if File.exist?("tmp/downloads/#{uuid}.mp4")
downloaded_image = open(youtube.information[:thumbnails].first[:url])
self.image.attach(io: downloaded_image  , filename: "thumbnail.jpg")
self.save


end

 




end #end of Episode Class

# comment again