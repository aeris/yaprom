class GitRepo < ActiveRecord::Base
	DIRECTORY = YamlConfig['git.repositories']

	inherits_from :repo, methods: true
	attr_reader :real_path, :clone_command
	belongs_to :project, class_name: GitProject
	belongs_to :owner, class_name: User
	belongs_to :origin, class_name: GitRepo

	before_validation do
		self.virtual_path = "#{self.project.uid}/#{self.owner.nil? ? 'upstream' : self.owner.uid}"
	end

	after_create :init_repo

	def init_repo
		Resque.enqueue ResqueTask::GitTask::InitRepository, self.id
	end

	def clone_command
		"git clone #{YamlConfig['ssh']}:#{self.virtual_path}"
	end

	def real_path
		"#{DIRECTORY}/#{self.uuid}.git"
	end

	def can_access?(user, access)
		case access
			when :write
				if self.owner.nil?
					# Upstream, only the project owner can write
					self.project.owner == user
				else
					# Only the repo owner can write
					self.owner == user
				end
			when :read
				if self.project.public?
					# Public repo, everybody can read
					true
				else
					# Private repo, only project members can read
					self.project.users.include? user
				end
		end
	end
end
