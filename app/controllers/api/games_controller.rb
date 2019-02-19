class Api::GamesController < ApplicationController

    skip_before_action :verify_authenticity_token
    before_action :verify_csrf_token, only: [:create, :update]

    def index
        if params[:user_id]
            if params[:user_id] == "current-user"
                if logged_in? 
                    @user = current_user
                else    
                    render json: JSON.generate("You must be logged in to view this information")
                end
            else
                @user = User.find(params[:user_id])
            end
            
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
        if(logged_in?)
            @user = current_user
            if(params[:game_type] == 'single_screen')
                @game = TankGame.new_singlescreen_game(current_user)
            else
                opponent = User.find(params[:opponent_id])
                @game = Tankgame.new_game(opponent, @user)

            end
            render 'show'
        else
            render json: JSON.generate({ errors: "You must be logged in to create a game" })
        end
    end

    def update
        if logged_in?
            @user = current_user
            @game = TankGame.find(params[:id])
            if @game.single_screen
                @game.update(singlescreen_game_params)
                @game.update(active: false) if @game.health_player_1 <= 0 || @game.health_player_2
            else    
                case params[:game_update_type]
                when :damage_done
                    victim = User.find(params[:user_id])
                    @game.register_hit(victim)
                when :turn_over
                    @game.end_turn(current_user)
                else 

                end
            end
            render 'show'
        else
            render json: JSON.generate({ errors: "You must be logged in to perform this action" })
        end 
    end


    private 

    def singlescreen_game_params
        params.permit([:number_of_turns, :health_player_1, :health_player_2])
    end


    def verify_csrf_token
        render json: JSON.generate({errors: "Invalid authenticity token" }) unless session[:csrf] == params[:authenticity_token]
    end

end