class AddRatingColumnToShares < ActiveRecord::Migration
  def self.up
     add_column :shares, :rating, :integer, :default => 0
  end

  def self.down
    remove_column :shares, :rating
  end
end
