class AddColoumnAccurateLocationRetailerstable < ActiveRecord::Migration
  def change
  	add_column :retailers, :accurate_lat, :decimal, :default => 0.0, :precision => 9, :scale => 6
  	add_column :retailers, :accurate_long, :decimal, :default => 0.0, :precision => 9, :scale => 6
  	add_column :retailers, :accurate_address, :string, :default => ""
  end
end
