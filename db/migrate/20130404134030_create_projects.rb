class CreateProjects < ActiveRecord::Migration
	def change
		create_table :projects do |t|
			t.string :subtype, null: false
			t.string :name, null: false
			t.string :uid, null: false
			t.string :description
			t.boolean :private , null: false, default: false
			t.references :owner, null: false, class: User

			t.timestamps
		end
		add_index :projects, :name, unique: true
		add_index :projects, :uid, unique: true

		create_table :git_projects, inherits: :project do |t|
		end

		create_table :svn_projects, inherits: :project do |t|
		end
	end
end
