class ChangeDefaultValuesRetailer < ActiveRecord::Migration
  def change
  	change_column_default(:retailers, :pan, '')
  	change_column_default(:retailers, :tin, '')
  	change_column_default(:retailers, :contact_number, '')
  end
end
