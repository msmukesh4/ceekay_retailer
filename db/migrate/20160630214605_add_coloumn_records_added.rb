class AddColoumnRecordsAdded < ActiveRecord::Migration
  def change
  	  	add_column :uploads, :records_added, :integer, :default => 0
  end
end
