class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

    	t.boolean :is_admin	
    	t.string :dse_code
    	t.string :name
    	t.date :dob
    	t.string :contact_number
    	t.string :email
    	t.string :password

      t.timestamps
    end
  end
end
