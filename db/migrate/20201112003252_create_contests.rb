class CreateContests < ActiveRecord::Migration[5.2]
  def change
    create_table :contests, force: true do |t|
      t.text :title
      t.text :description
      t.text :terms
      t.boolean :allow_multiple_entries, default: false
      t.daterange :duration
      t.boolean :approved

      t.references :prompt, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
