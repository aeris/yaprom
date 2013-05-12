class CreateRepos < ActiveRecord::Migration
	def change
		create_table :repos do |t|
			t.string :uuid, null: false
			t.string :subtype, null: false
			t.string :virtual_path, null: false
			t.timestamps
		end
		add_index :repos, :uuid, unique: true

		create_table :git_repos, inherits: :repo do |t|
			t.references :owner, class: User
			t.references :project, null: false, class: GitProject
			t.references :origin, class: GitRepo
		end

		create_table :svn_repos, inherits: :repo do |t|
			t.references :project, null: false, class: SvnProject
		end
	end
end
