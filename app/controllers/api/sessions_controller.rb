class Api::SessionsController < ApplicationController


    def create
        user = User.find_by(username: params[:username])
        if user.authenticate(params[:password])
            session[:user_id] = user.id
            @res = { login: :success }
            
        else
            @res = { login: :failure }
        end
        render json: JSON.generate(@res)
    end

    def destroy
        session.delete(:user_id)
        render json: JSON.generate({logout: :success})
    end

    def csrf_token
        if request.headers["X-HANDSHAKE-TOKEN"] == ENV['X-HANDSHAKE-TOKEN']
            token = form_authenticity_token
            session[:csrf] = token
            render json: JSON.generate({csrfToken: token})
        else
            render json: JSON.generate({data: "handshake failed"})
        end
    end


end