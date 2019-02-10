class SessionsController < ApplicationController


    def create
        user = User.find_by(username: params[:username])
        if user.authenticate(params[:password])
            session[:user_id] = user.id
            @res = { login: :success }
            
        else
            @res = { login: :failure }
        end
        render :json JSON.generate(res)
    end

    def destroy
        session.delete(:user_id)
        render :json JSON.generate({logout: :success})
    end


end