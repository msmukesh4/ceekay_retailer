class ChangeAddressDefaultValuesRetailer < ActiveRecord::Migration
  def change
  	  change_column_default(:retailers, :address, '')
  end
end
