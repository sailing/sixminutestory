class AddStartLineOnPrompts < ActiveRecord::Migration[5.0]
  def change
  	add_column :prompts, :firstline, :text
  end
end
