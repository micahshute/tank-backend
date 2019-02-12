class ApplicationController < ActionController::Base

    before_action :verify_header

    private

    def current_user
        if logged_in? 
            User.find(session[:user_id])
        else
            nil
        end
    end

    def logged_in?
        !!session[:user_id]
    end

    def valid_game?(type)
        return Game.valid?(type)
    end

    def verify_header
        render json: JSON.generate({errors: "Invalid request"}) unless request.headers["X-HANDSHAKE-TOKEN"] == ENV['X-HANDSHAKE-TOKEN']
    end
end
