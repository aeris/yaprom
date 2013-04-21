class MeController < ApplicationController
	def index
	end

	def password
		if params[:password_new] == params[:password_confirm]
			unless @me.check params[:password_current]
				flash[:error] = 'Invalid password'
			else
				@me.password = User.hash_password params[:password_new]
				@me.save
				flash[:success] = 'Password changed successfully'
			end
		else
			flash[:error] = 'Passwords don\'t match'
		end

		redirect_to me_path
	end
end
