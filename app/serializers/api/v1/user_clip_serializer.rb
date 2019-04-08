class Api::V1::UserClipSerializer < ActiveModel::Serializer
  attributes :id, :clip_id, :user_id
end
