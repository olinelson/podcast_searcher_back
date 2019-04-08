class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id ,:email, :clips, :user_name, :user_clips
  
end
