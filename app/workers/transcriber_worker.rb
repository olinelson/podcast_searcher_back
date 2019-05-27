class TranscriberWorker
  include Sidekiq::Worker

  require "google/cloud/speech"
  require "google/cloud/storage"

  def perform(clip_id)

      clip = Clip.find(clip_id)

    # [START speech_transcribe_async]
      storage_path = clip.gcloud_service_link + "processed.flac"

      

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
        clip.transcript = "#{clip.transcript} #{alternative.transcript}"

      alternative.words.each do |word|
      start_time = word.start_time.seconds + word.start_time.nanos/1000000000.0
        end_time   = word.end_time.seconds + word.end_time.nanos/1000000000.0

        new_word = { word:word.word, start_time: start_time, end_time: end_time}.to_json
        wordsArray.push(new_word)
      end
      clip.words = wordsArray
    
    end
    end
    clip.processing = false
    clip.save
    # clip.send_clip_done_email
  end
end
