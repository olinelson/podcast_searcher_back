class Api::V1::EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :name, :length, :transcript, :words, :podcast, :audio_file_url
end
