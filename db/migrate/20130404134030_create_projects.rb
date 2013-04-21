class CreateProjects < ActiveRecord::Migration
	def change
		create_table :projects do |t|
			t.string :name, null: false
			t.string :uid, null: false
			t.string :description
			t.string :scm, null: false
			t.references :owner, null: false, class: User

			t.timestamps
		end

		add_index :projects, :name, unique: true
		add_index :projects, :uid, unique: true
	end
end
