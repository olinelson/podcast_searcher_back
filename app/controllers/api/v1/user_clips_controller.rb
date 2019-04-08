class Api::V1::UserClipsController < ApplicationController
    def create 
        @user = curr_user
        UserClip.create(user_id: @user.id, clip_id: params[:clip_id])
    
    end

    def index 
        @user_clips = UserClip.all 
        render json: @user_clips
    end

    def unsave
        @user = curr_user
        @user_clip = UserClip.find_by clip_id: params[:clip_id], user_id: @user.id
        @user_clip.delete
    end
end
