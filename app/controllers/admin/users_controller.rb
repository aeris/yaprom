class Admin::UsersController < Admin::SiteController
	def show
	end

	def create
		redirect_to admin_path
	end
end
