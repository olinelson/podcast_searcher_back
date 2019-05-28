class Api::V1::UsersController < ApplicationController

  before_action :find_user, only: [:update, :show, :destroy]

  def index
    @users = User.all
    json_string = Api::V1::UserSerializer.new(@users).serialized_json
    render json: json_string

  end

  def show
    json_string = Api::V1::UserSerializer.new(@user).serialized_json
    render json: json_string
  end

   def create

    @user = User.new(user_params)
    if @user.save
        jwt = encode_token(@user.id)
        json_string = Api::V1::UserSerializer.new(@user).serialized_json
        render json: json_string

    else
        render json: {errors: @user.errors} 
    end

  end


def login
  @user = User.find_by_email(params[:email])
  if @user.password == params[:password]
    give_token
  else
    redirect_to home_url
  end
end

def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:email, :password, :user_name)
  end

end


