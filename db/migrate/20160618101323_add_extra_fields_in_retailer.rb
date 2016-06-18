class AddExtraFieldsInRetailer < ActiveRecord::Migration
  def change
  	add_column :retailers, :contact_number, :string, :limit => 15
  	add_column :retailers, :is_active, :boolean, :default => true
  	add_column :retailers, :pan, :string, :limit => 15
  	add_column :retailers, :tin, :string, :limit => 15
  end
end
