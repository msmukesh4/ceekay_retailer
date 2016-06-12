class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|

    	t.string :file_name, :null => false
    	t.string :path, :null => false
      	t.timestamps
    end
  end
end
