class AddBranchColoumntoRetailer < ActiveRecord::Migration
  def change
  	add_column :retailers, :branch_code, :string
  end
end
