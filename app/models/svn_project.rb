class SvnProject < ActiveRecord::Base
	inherits_from :project, methods: true
	has_one :repo, class_name: SvnRepo

	def scm
		:svn
	end

	def repo_for(user)
		self.repo
	end

	def upstream
		self.repo_for nil
	end
end
