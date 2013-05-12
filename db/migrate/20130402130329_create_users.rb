class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :uid, null: false
			t.string :common_name, null: false
			t.string :surname, null: false
			t.string :password
			t.string :email, null: false
			t.boolean :admin, null: false, default: false

			t.timestamps
		end

		add_index :users, :uid, unique: true
		add_index :users, :email, unique: true
	end
end
