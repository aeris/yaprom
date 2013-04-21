class CreateSshKeys < ActiveRecord::Migration
	def change
		create_table :ssh_keys do |t|
			t.references :user, null: false
			t.string :fingerprint, null: false
			t.string :key_type, null: false
			t.string :base64, null: false
			t.string :comment, null: false
			t.integer :size, null: false

			t.timestamps
		end

		add_index :ssh_keys, :user_id
	end
end
