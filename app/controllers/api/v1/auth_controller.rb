class Api::V1::AuthController < ApplicationController

    def create

        @user   = User.all.find_by(email: params[:email])

        if @user && @user.authenticate(params[:password])
            jwt = encode_token(@user.id)

            render json: {user: Api::V1::UserSerializer.new(@user), jwt: jwt}

        else
            render json: {errors: "incorrect user or password"}
        end
        
    end

    def auto_login

       if logged_in

      render json: {user: Api::V1::UserSerializer.new(curr_user)}
    else
      render json: {errors: "You dun goofed!"}
end
    end

end
