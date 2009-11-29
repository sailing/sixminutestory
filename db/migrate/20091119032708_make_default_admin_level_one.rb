class MakeDefaultAdminLevelOne < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :admin_level, :integer, :default => 1
    end
  end

  def self.down
    change_table :users do |t|
      t.change :admin_level, :integer, :default => nil
    end
  end
end
