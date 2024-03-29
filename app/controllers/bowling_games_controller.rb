class BowlingGamesController < ApplicationController
  before_action :set_game, except: :create

  def create
    initial_score = game_params[:number_of_pins_knocked_down].to_i
    @bowling_game = BowlingGame.new(
      total_score: initial_score,
      current_frame: 1,
      bonus_balls_for_current_frame: initial_score == 10 ? 2 : 0,
      current_frame_ball: 1,
      current_frame_score: initial_score
    )
    
    if @bowling_game.save
      render json: BowlingGameSerializer.new(@bowling_game).serializable_hash, status: :created
    else
      render json: { errors: @bowling_game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    current_score = game_params[:number_of_pins_knocked_down].to_i
    
    if @bowling_game.current_frame == 10 && @bowling_game.bonus_balls_for_current_frame == 0 && @bowling_game.current_frame_ball >= 2
      return render json: { 
        message: "Game Finished",
        game_id: @bowling_game.id,
        total_score: @bowling_game.total_score
        }, status: :ok
    end
    
    if @bowling_game.bonus_balls_for_current_frame != 0
      @bowling_game.total_score += current_score
      @bowling_game.current_frame_score += current_score
      @bowling_game.current_frame_ball += 1
      @bowling_game.bonus_balls_for_current_frame -= 1
    elsif @bowling_game.bonus_balls_for_current_frame == 0 
      if @bowling_game.current_frame_ball >= 2
        @bowling_game.total_score += current_score
        @bowling_game.current_frame += 1
        @bowling_game.current_frame_score = current_score
        @bowling_game.current_frame_ball = 1
        @bowling_game.bonus_balls_for_current_frame = current_score == 10 ? 2 : 0
      elsif (current_score + @bowling_game.current_frame_score) == 10
        @bowling_game.total_score += current_score
        @bowling_game.current_frame_score += current_score
        @bowling_game.current_frame_ball += 1
        @bowling_game.bonus_balls_for_current_frame = 1
      elsif (current_score + @bowling_game.current_frame_score) != 10
        @bowling_game.total_score += current_score
        @bowling_game.current_frame_score += current_score
        @bowling_game.current_frame_ball += 1
      end
    end

    if @bowling_game.save
      render json: BowlingGameSerializer.new(@bowling_game).serializable_hash, status: :ok
    else
      render json: { errors: @bowling_game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: BowlingGameSerializer.new(@bowling_game).serializable_hash, status: :ok
  end

  private

  def game_params
    params.require(:bowling_game).permit(
      :number_of_pins_knocked_down
    )
  end

  def set_game
    @bowling_game = BowlingGame.find(params[:id])
  end
end
