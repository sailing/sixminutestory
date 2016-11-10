class AddStartLineOnPrompts < ActiveRecord::Migration[5.0]
  def change
  	add_column :prompts, :start_line, :text
  end
end
