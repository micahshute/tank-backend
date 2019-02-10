class CreateUserGames < ActiveRecord::Migration[5.2]
  def change
    create_table :user_games do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :game, polymorphic: true, index: true
    end
  end
end
