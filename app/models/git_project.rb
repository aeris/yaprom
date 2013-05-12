class GitProject < ActiveRecord::Base
	inherits_from :project, methods: true
	attr_reader :upstream
	has_many :repos, class_name: GitRepo, foreign_key: :project_id
	has_many :users, through: :repos, source: :owner

	def repo_for(user)
		GitRepo.where(project_id: self, owner_id: user).first
	end

	def upstream
		self.repo_for nil
	end

	after_create do
		upstream = GitRepo.create do |r|
			r.project = self
			r.owner = nil
			r.origin = nil
		end
		GitRepo.create do |r|
			r.project = self
			r.owner = self.owner
			r.origin = upstream
		end
	end

	def scm
		:git
	end

	def add_member(user)
		GitRepo.create do |r|
			r.project = self
			r.owner = user
			r.origin = self.upstream
		end unless self.users.include? user
	end
end
