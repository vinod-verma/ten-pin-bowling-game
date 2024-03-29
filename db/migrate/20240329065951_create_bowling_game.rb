class CreateBowlingGame < ActiveRecord::Migration[7.0]
  def change
    create_table :bowling_games do |t|
      t.integer :total_score
      t.integer :current_frame
      t.integer :bonus_balls_for_current_frame
      t.boolean :current_frame_status
      t.integer :current_frame_score
      t.integer :current_frame_ball

      t.timestamps
    end
  end
end
