class AdminController < ApplicationController
	before_filter :require_admin

	def require_admin
		render :forbidden unless @me.admin?
	end

	def forbidden
	end

	def index
		@user = User.new password: User.generate_password
		@project = Project.new
	end

	def create_missing
		@created = []
		GitRepo.all.each do |r|
			unless Dir.exist? r.real_path
				r.init_repo
				@created << r
			end
		end
	end
end
