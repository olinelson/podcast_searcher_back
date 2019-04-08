class Api::V1::UsersController < ApplicationController

  before_action :find_user, only: [:update, :show, :destroy]

  def index
    @users = User.all
    render json: @users

  end

  def show
    render json: @user #,  methods: :audio_file_url
  end

   def create

    @user = User.new(user_params)
    if @user.save
        jwt = encode_token(@user.id)
        render json: @user
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


