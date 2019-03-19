class Api::V1::ClipSerializer < ActiveModel::Serializer
  attributes :id, :name, :length, :transcript, :words, :gcloud_service_link, :gcloud_media_link, :tags
end
