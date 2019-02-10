class Api::GamesController < ApplicationController

    def index
        if params[:user_id]
            @user = User.find(params[:user_id])
            if type = params[:type]
                if valid_game?(params[:type])
                    @games = @user.send(type)
                else
                    error = OpenStruct.new
                    error.msg = "#{type} is an invalid game type"
                    error.status = "404"
                    render "api/error", locals: {error: error}, status: 404
                end
                
            else
                @games = @user.games
            end
        else
            @games = Game.all
        end
    end

    def show
        type = params[:type]
        if valid_game?(type)
            @user = User.find(params[:user_id]) if params[:user_id]
            @game = type.slice(0, type.length - 1).camelcase.constantize.find(params[:id])
        else
            error = OpenStruct.new
            error.msg = "#{type} is an invalid game type"
            error.status = "404"
            render "api/error", locals: {error: error}, status: 404
        end
    end


    def create
        binding.pry
    end

    def update
        binding.pry
    end


end