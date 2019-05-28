class Api::V1::ClipSerializer
  include FastJsonapi::ObjectSerializer
attributes :id, :processing, :name, :length, :transcript, :words, :gcloud_service_link, :gcloud_media_link, :gcloud_image_link, :tags, :users, :author, :media_type
belongs_to :author, foreign_key: 'author_id', class_name: 'User' 


end
