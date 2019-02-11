class Api::SessionsController < ApplicationController

    skip_before_action :verify_authenticity_token


    def create
        if session[:csrf] == params[:authenticity_token]
            user = User.find_by(username: params[:username])
            if !!user and user.authenticate(params[:password])
                session[:user_id] = user.id
                @res = { login: :success }
                
            else
                @res = { login: :failure, error: "Username/password combination incorrect" }
            end   
        else
            @res = { login: :failure, error: "Invalid authenticity token"}
        end
        render json: JSON.generate(@res)
    end

    def destroy
        session.delete(:user_id)
        session.delete(:csrf)
        render json: JSON.generate({logout: :success})
    end

    def csrf_token
        if request.headers["X-HANDSHAKE-TOKEN"] == ENV['X-HANDSHAKE-TOKEN']
            token = form_authenticity_token
            session[:csrf] = token
            render json: JSON.generate({csrfToken: token, logged_in: logged_in?})
        else
            render json: JSON.generate({data: "handshake failed"})
        end
    end


end