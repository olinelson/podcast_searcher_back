class Episode < ApplicationRecord
    require "google/cloud/speech"

    has_one_attached :audio_file
    belongs_to :podcast

    def audio_file_url
        if self.audio_file.attached?
            Rails.application.routes.url_helpers.rails_blob_path(self.audio_file, only_path: true)
        
        else
            nil
        end
    end

<<<<<<< HEAD


#     def convert_mp3_to_flac
#         mp3_path = ActiveStorage::Blob.service.path_for(self.audio_file.key)
#   flac_path = mp3_path.gsub(".m4a", ".flac")
#   system("ffmpeg -i #{m4a_path} #{flac_path}")
#   end 
=======
#     def justPath 
#          "#{ActiveStorage::Blob.service.path_for(self.audio_file.key)}/#{self.audio_file.filename.to_s}"
#     end
>>>>>>> fileUploaderOnly

    def convert_mp3_to_flac
    mp3_path = ActiveStorage::Blob.service.path_for(self.audio_file.key)
    flac_path = mp3_path.gsub(".mp3", ".flac")
    system("ffmpeg -i #{mp3_path} #{flac_path}")
    end 


   def process_audio audio_file_path: nil
# [START speech_transcribe_async]
  audio_file_path = ActiveStorage::Blob.service.path_for(self.audio_file.key)

  require "google/cloud/speech"

  speech = Google::Cloud::Speech.new

  # [START speech_ruby_migration_async_response]
  # [START speech_ruby_migration_async_request]
  audio_file = File.binread audio_file_path
  config     = { encoding:          :FLAC,
                 sample_rate_hertz: 44100,
                 language_code:     "en-US",
                enable_word_time_offsets: true,   }
  audio      = { content: audio_file }

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

  

  
  # [END speech_ruby_migration_async_response]
# [END speech_transcribe_async]
end

end #end of Episode Class
