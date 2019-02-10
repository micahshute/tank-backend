class CreateTankGames < ActiveRecord::Migration[5.2]
  def change
    create_table :tank_games do |t|
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
