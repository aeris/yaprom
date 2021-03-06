class MeController < ApplicationController
	def index
	end

	def password
		auth = Rails.configuration.auth_provider
		if params[:password_new] == params[:password_confirm]
			unless auth.authenticate @me.uid, params[:password_current]
				flash[:error] = 'Invalid password'
			else
				@me.password = User.hash_password params[:password_new]
				@me.save
				auth.change_password @me, params[:password_current], params[:password_new]
				flash[:success] = 'Password changed successfully'
			end
		else
			flash[:error] = 'Passwords don\'t match'
		end

		redirect_to me_path
	end
end
