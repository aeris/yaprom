class SiteController < ApplicationController
	skip_before_filter :require_login, :only => [:login, :auth]

	def index
	end

	def login
	end

	def auth
		user = User.where(uid: params[:login], password: User.hash_password(params[:password])).first
		if user
			session[:me] = user.id
			flash[:success] = 'Login success'
			redirect_to_with_from me_path
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
