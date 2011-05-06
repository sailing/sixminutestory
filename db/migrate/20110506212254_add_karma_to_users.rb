class AddKarmaToUsers < ActiveRecord::Migration
  def self.up
		add_column :users, :karma, :double, :default => 0
  end

  def self.down
		remove_column :users, :karma
  end
end