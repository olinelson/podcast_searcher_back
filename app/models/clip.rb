class Clip < ApplicationRecord
    require "google/cloud/speech"
    require "google/cloud/storage"

    has_one_attached :audio_file

    has_many :cliptags
    has_many :tags, through: :cliptags


    def get_gcloud_links
        self.gcloud_service_link = "gs://bucket-of-doom/#{self.audio_file.key}"
        self.gcloud_media_link = "https://storage.googleapis.com/bucket-of-doom/#{self.audio_file.key}"
        
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
  self.save
end
end

end #end


end #end of Episode Class
