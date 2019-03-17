class Api::V1::ClipSerializer < ActiveModel::Serializer
  attributes :id, :name, :length, :transcript, :words, :audio_file_url
end
