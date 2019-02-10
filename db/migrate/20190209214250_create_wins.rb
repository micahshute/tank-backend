class CreateWins < ActiveRecord::Migration[5.2]
  def change
    create_table :wins do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :game, polymorphic: true, index: true

      t.timestamps
    end
  end
end
