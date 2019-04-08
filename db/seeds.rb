#  export GOOGLE_APPLICATION_CREDENTIALS="config/secrets/podcastsearcher.json"

# gcloud auth activate-service-account --key-file google-creds.json


# export GOOGLE_APPLICATION_CREDENTIALS='ENV['GOOGLE_APPLICATION_CREDENTIALS']'

# export GOOGLE_APPLICATION_CREDENTIALS="$(< ENV["GOOGLE_APPLICATION_CREDENTIALS"])"

# # Dummy Podcasts

# Clip.delete_all

# require 'rest-client'

# def create_flac_copy(inputFormat, originalFileName, newFileName)
 
#   url = 'https://api.cloudconvert.com/convert?apikey=' + ENV["CLOUD_CONVERT_KEY"] + '&inputformat=' + inputFormat + '&outputformat=flac&input[googlecloud][projectid]=' + ENV["PROJECT_ID"] + '&input[googlecloud][bucket]=bucket-of-doom&input[googlecloud][credentials][type]=service_account&input[googlecloud][credentials][project_id]=' + ENV["PROJECT_ID"] +'&input[googlecloud][credentials][private_key_id]=' + ENV["PRIVATE_KEY_ID"] + '&input[googlecloud][credentials][private_key]=' + ENV["PRIVATE_KEY"] + '&input[googlecloud][credentials][client_email]=' + ENV["CLIENT_EMAIL"] + '&input[googlecloud][credentials][client_id]=' + ENV["CLIENT_ID"] + '&input[googlecloud][credentials][auth_uri]=' + ENV["AUTH_URI"] + '&input[googlecloud][credentials][token_uri]=' + ENV["TOKEN_URI"] + '&input[googlecloud][credentials][auth_provider_x509_cert_url]=' + ENV["AUTH_PROVIDER"] +'&input[googlecloud][credentials][client_x509_cert_url]='+ ENV["CLIENT_CERT"] +'&file=' + originalFileName + '&converteroptions[audio_codec]=FLAC&converteroptions[audio_bitrate]=128&converteroptions[audio_channels]=1&converteroptions[audio_frequency]=44100&converteroptions[strip_metatags]=false&output[googlecloud][projectid]=' + ENV["PROJECT_ID"] + '&output[googlecloud][bucket]=bucket-of-doom&output[googlecloud][credentials][type]=service_account&output[googlecloud][credentials][project_id]=' + ENV["PROJECT_ID"] +'&output[googlecloud][credentials][private_key_id]=' + ENV["PRIVATE_KEY_ID"] + '&output[googlecloud][credentials][private_key]=' + ENV["PRIVATE_KEY"] + '&output[googlecloud][credentials][client_email]=' + ENV["CLIENT_EMAIL"] + '&output[googlecloud][credentials][auth_uri]=' + ENV["AUTH_URI"] + '&output[googlecloud][credentials][token_uri]=' + ENV["TOKEN_URI"] + '&output[googlecloud][credentials][auth_provider_x509_cert_url]=' + ENV["AUTH_PROVIDER"] +'&output[googlecloud][credentials][client_x509_cert_url]='+ ENV["CLIENT_CERT"] +'&output[googlecloud][path]='+ newFileName + '&wait=true&download=false'
#   RestClient.get url
#   # puts url
# end

# create_flac_copy("mp3", "mp3testfile.mp3", "testfromseedfile.flac")

# Clip.all.each do |c|
#   c.media_type = "audio"
#   c.save
# end

# newVideo =  YoutubeDL.download "https://www.youtube.com/watch?v=dYDEMCvB8cU", output: 'youtubedownloadedfile.mp4'

