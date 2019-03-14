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

#     def convert_mp3_to_flac(mp3_path)
#   flac_path = mp3_path.gsub(".mp3", ".flac")
#   system("ffmpeg -i #{mp3_path} #{flac_path}")
# end 


   def speech audio_file_path: nil
# [START speech_transcribe_async]
  audio_file_path = ActiveStorage::Blob.service.path_for(self.audio_file.key)

  require "google/cloud/speech"

  speech = Google::Cloud::Speech.new

  # [START speech_ruby_migration_async_response]
  # [START speech_ruby_migration_async_request]
  audio_file = File.binread audio_file_path
  config     = { encoding:          :FLAC,
                 sample_rate_hertz: 44100,
                 language_code:     "en-US"   }
  audio      = { content: audio_file }

  operation = speech.long_running_recognize config, audio

  puts "Operation started"

  operation.wait_until_done!

  raise operation.results.message if operation.error?

  results = operation.response.results
  # [END speech_ruby_migration_async_request]

  alternatives = results.first.alternatives
  alternatives.each do |alternative|
    puts "Transcription: #{alternative.transcript}"
  end
  # [END speech_ruby_migration_async_response]
# [END speech_transcribe_async]
end

end #end of Episode Class
