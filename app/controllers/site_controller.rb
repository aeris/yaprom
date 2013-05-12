class SiteController < ApplicationController
	skip_before_filter :require_login, only: [:login, :auth]

	def index
	end

	def login
	end

	def auth
		user = Rails.configuration.auth_provider.authenticate params[:login], params[:password]
		if user
			session[:me] = user.id
			flash[:success] = 'Login success'
			redirect_to me_path
		else
			flash[:error] = 'Authentication error'
			redirect_to :login
		end
	end

	def logout
		session.delete :me
		flash[:success] = 'Logout success'
		redirect_to me_path
	end
end
