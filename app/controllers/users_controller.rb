class UsersController < ApplicationController
	skip_before_filter :require_login , :only => [:new, :create]

	def new
		@user = User.new
	end

	def create
		@user = User.new params[:user]
		if @user.save
			session[:me] = @user.id
			redirect_to me_path
		else
			render :new
		end
	end
end
