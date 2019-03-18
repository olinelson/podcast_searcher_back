class Clip < ApplicationRecord
    require "google/cloud/speech"
    require "google/cloud/storage"

    has_one_attached :audio_file


    def audio_file_url
        if self.audio_file.attached?
            Rails.application.routes.url_helpers.rails_blob_path(self.audio_file, only_path: true)
        
        else
            nil
        end
    end

    def audio_file_path
        ActiveStorage::Blob.service.path_for(self.audio_file.key)
    end

    def upload_to_gcloud
        
        storage = Google::Cloud::Storage.new
        bucket = storage.bucket "bucket-of-doom"
        bucket.create_file audio_file_path
        
    end

    def delete_local_file
        self.audio_file.purge
    end

    def gcloud_audio_link
        storage = Google::Cloud::Storage.new
        bucket = storage.bucket "bucket-of-doom"
        file = bucket.file audio_file_path
        "https://storage.googleapis.com/bucket-of-doom/#{file.name}"
    
    end


   def process_audio audio_file_path: nil
# [START speech_transcribe_async]
  storage_path = self.gcloud_service_link

  require "google/cloud/speech"

  speech = Google::Cloud::Speech.new

  # [START speech_ruby_migration_async_response]
  # [START speech_ruby_migration_async_request]
  
  config     = { encoding:          :FLAC,
                 sample_rate_hertz: 44100,
                 language_code:     "en-US",
                enable_word_time_offsets: true, 
                
            }
  audio      = { uri: storage_path }

  operation = speech.long_running_recognize config, audio

  puts "Operation started"

  operation.wait_until_done!

  raise operation.results.message if operation.error?

  results = operation.response.results
  # [END speech_ruby_migration_async_request]
alternatives = results.first.alternatives
alternatives.each do |alternative|
    self.transcript = alternative.transcript
#   puts "Transcription: #{alternative.transcript}"
#   puts "Words: #{alternative.words}"
    wordsArray = []
  alternative.words.each do |word|
    puts word.start_time.seconds
   start_time = word.start_time.seconds + word.start_time.nanos/1000000000.0
    end_time   = word.end_time.seconds + word.end_time.nanos/1000000000.0

    new_word = { word:word.word, start_time: start_time, end_time: end_time}.to_json
    wordsArray.push(new_word)
  end
   self.words = wordsArray
  self.save
end

  

  
#   [END speech_ruby_migration_async_response]
# [END speech_transcribe_async]
end

# def process_audio 
# storage_path = self.gcloud_service_link

# require "google/cloud/speech"

# speech = Google::Cloud::Speech.new

# config     = { encoding:          :FLAC,
#                sample_rate_hertz: 44100,
#                language_code:     "en-US"   }
# audio  = { uri: storage_path }

# operation = speech.long_running_recognize config, audio

# puts "Operation started"

# operation.wait_until_done!

# raise operation.results.message if operation.error?

# results = operation.response.results

# alternatives = results.first.alternatives
# alternatives.each do |alternative|
#   puts "Transcription: #{alternative.transcript}"
# end  
# end

end #end of Episode Class
