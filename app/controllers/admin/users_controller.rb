class Admin::UsersController < AdminController
	def create
		mail = params[:send_password_by_mail]
		@user = User.new params[:user]
		if @user.save
			session[:me] = @user.id
			flash[:success] = 'User registered successfully'
			redirect_to admin_path
		end
	end
end
