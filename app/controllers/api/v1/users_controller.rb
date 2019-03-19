class Api::V1::UsersController < ApplicationController
     def create
    @user = User.new(params[:user])
    @user.password = params[:password]
    # @user.save!
    if @user.save
        render json: user
    else
        render json: {errors: user.errors} 
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

end
