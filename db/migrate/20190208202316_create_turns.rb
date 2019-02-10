class CreateTurns < ActiveRecord::Migration[5.2]
  def change
    create_table :turns do |t|
      t.belongs_to :game, polymorphic: true, index: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
