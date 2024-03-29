class BowlingGameSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :total_score, :current_frame, :current_frame_score, :current_frame_ball, :bonus_balls_for_current_frame
end