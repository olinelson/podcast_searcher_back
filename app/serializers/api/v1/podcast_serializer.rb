class Api::V1::PodcastSerializer < ActiveModel::Serializer
  attributes :id, :name, :episodes
end
