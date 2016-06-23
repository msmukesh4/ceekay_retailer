class AddMoreLocationsRetailerstable < ActiveRecord::Migration
  def change
  	add_column :retailers, :latitude2, :decimal, :default => 0.0, :precision => 9, :scale => 6
  	add_column :retailers, :longitude2, :decimal, :default => 0.0, :precision => 9, :scale => 6
  	add_column :retailers, :latitude3, :decimal, :default => 0.0, :precision => 9, :scale => 6
  	add_column :retailers, :longitude3, :decimal, :default => 0.0, :precision => 9, :scale => 6
  	add_column :retailers, :address2, :string, :default => ""
  	add_column :retailers, :address3, :string, :default => ""
  	add_column :retailers, :has_inconsistent_addresses, :boolean, :default => false
  end
end
