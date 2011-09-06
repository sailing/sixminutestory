class AddLicenseFieldsToPrompt < ActiveRecord::Migration
  def self.up
		add_column :prompts, :license_url, :string
		add_column :prompts, :license_en, :string
		add_column :prompts, :license_image_url, :string
  end

  def self.down
		remove_column :prompts, :license_image_url
		remove_column :prompts, :license_en
		remove_column :prompts, :license_url
  end
end