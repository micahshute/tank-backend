class Api::UsersController < ApplicationController

    skip_before_action :verify_authenticity_token

    def index
        @users = User.all
        session[:test] = "test"
    end

    def show
        @user = User.find(params[:id])
    end

    def create
        # user = User.new(username: params[:username], password: params[:password])
        user = User.new(user_params)
        if(user.save)
            render json: JSON.generate({signup: :success})
        else
            render json: JSON.generate({signup: :failure, errors: user.errors.full_messages})
        end
    end


    private

    def user_params
        params.permit([:username, :password])
    end




end