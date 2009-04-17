class AddLicenseToShares < ActiveRecord::Migration
  def self.up
    add_column :shares, :license, :string
  end

  def self.down
    remove_column :shares, :license
  end
end
