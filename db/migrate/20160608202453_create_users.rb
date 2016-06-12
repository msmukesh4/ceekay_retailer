class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :email
      t.string :password
      t.boolean :is_first_logged_in, :default => false
    	t.boolean :is_admin, :default => false
    	t.string :dse_code
    	t.string :name
    	t.date :dob
    	t.string :contact_number
      t.timestamps
    end
  end
end
