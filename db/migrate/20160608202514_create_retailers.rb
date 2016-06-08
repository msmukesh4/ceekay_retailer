class CreateRetailers < ActiveRecord::Migration
  def change
    create_table :retailers do |t|

    	t.string :retailer_code
    	t.string :retailer_name
    	t.string :dse_code
    	t.string :route_no
    	t.string :address
    	t.decimal :latitude, :default => 0.0, :precision => 9, :scale => 6
    	t.decimal :longitude, :default => 0.0, :precision => 9, :scale => 6

      t.timestamps
    end
  end
end
