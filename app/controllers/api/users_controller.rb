class Api::UsersController < ApplicationController

    skip_before_action :verify_authenticity_token

    def index
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
    end

    def create
        # binding.pry
        # user = User.new(username: params[:username], password: params[:password])
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


    private

    def user_params
        params.permit([:username, :password])
    end




end