class CreateWinners < ActiveRecord::Migration[5.2]
  def change
    create_table :winners do |t|
      t.string :winner_type, null: false

      t.references :contest, foreign_key: true, null: false
      t.references :story, foreign_key: true, null: false 
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
