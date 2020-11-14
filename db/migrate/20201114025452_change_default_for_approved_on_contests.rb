class ChangeDefaultForApprovedOnContests < ActiveRecord::Migration[5.2]
  def change
    change_column :contests, :approved, :boolean, default: false
  end
end
