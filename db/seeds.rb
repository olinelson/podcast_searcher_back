# Dummy Podcasts
Podcast.delete_all
Episode.delete_all


Podcast.create(name: "new Podcast")
Episode.create(name: "Olaf's episode", length: "long", podcast_id: Podcast.first.id)

Episode.first.audio_file.attach(
        io: File.open(Rails.root.join('resources', 'audio-file.flac')),
        filename: 'audio-file.flac', content_type: 'audio/flac'
      )






# Imports the Google Cloud client library
require "google/cloud/speech"

# Instantiates a client
speech = Google::Cloud::Speech.new

# The name of the audio file to transcribe
file_name = "./resources/audio-file.flac"

# The raw audio
audio_file = File.binread file_name

# The audio file's encoding and sample rate
config = { encoding:          :FLAC,
           sample_rate_hertz: 44100,
           language_code:     "en-US",
            enable_word_time_offsets: true
              }
audio  = { content: audio_file }

# Detects speech in the audio file
response = speech.recognize config, audio

results = response.results

# Get first result because we only processed a single audio file
# Each result represents a consecutive portion of the audio
results.first.alternatives.each do |alternatives|
   puts "Transcription: #{alternatives.words}"
  puts "Transcription: #{alternatives.transcript}"
  @episode = Episode.first
  @episode.transcript = "#{alternatives.transcript}"
  @episode.words = "#{alternatives.words}"
  @episode.save
 
end


puts Episode.first

