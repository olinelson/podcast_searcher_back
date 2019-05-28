class Api::V1::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :clips, :email, :user_name

end
