class AddReputationToUsers < ActiveRecord::Migration
  def self.up
		add_column :users, :reputation, :integer, :default => 0
  end

  def self.down
		remove_column :users, :reputation
  end
end