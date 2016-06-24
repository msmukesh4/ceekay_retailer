class AddStatusFieldUploadtable < ActiveRecord::Migration
  def change
  	add_column :uploads, :is_completed, :boolean, :default => false
  end
end
