class Api::V1::EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :name, :length, :metadata, :podcast, :audio_file_url
end
