class CreateTankGames < ActiveRecord::Migration[5.2]
  def change
    create_table :tank_games do |t|
      t.boolean :active, default: true
      t.integer :number_of_turns, default: 0
      t.boolean :single_screen, default: false
      t.integer :health_player_1, default: 3
      t.integer :health_player_2, default: 3
      t.timestamps
    end
  end
end
