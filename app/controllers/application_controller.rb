class ApplicationController < ActionController::Base

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
end
