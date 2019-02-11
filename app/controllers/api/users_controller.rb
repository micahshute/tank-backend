class Api::UsersController < ApplicationController

    skip_before_action :verify_authenticity_token

    def index
        @users = User.all
    end

    def show
        if (params[:id] == "current-user") and logged_in?
            @user = current_user
        elsif params[:id].to_i != 0
            @user = User.find(params[:id])
        else
            render json: JSON.generate({ error: "Could not find user" })
        end
    end

    def create
        if session[:csrf] == params[:authenticity_token]
            user = User.new(user_params)
            if(user.save)
                session[:user_id] = user.id
                render json: JSON.generate({signup: :success})
            else
                render json: JSON.generate({signup: :failure, errors: user.errors.full_messages})
            end
        else
            render json: JSON.generate({signup: :failure, errors: "Unable to verify authenticity token"})
        end
    end


    def username_check
        taken = !!User.find_by(username: params[:username])
        render json: JSON.generate({taken: taken})
    end

    private

    def user_params
        params.permit([:username, :password])
    end




end