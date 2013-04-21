class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :require_login

	def require_login
		if session[:me]
			@me = User.find session[:me]
		else
			flash[:error] = 'Authentication required'
			session[:from] = request.url
			redirect_to login_path
		end
	end

	def redirect_to_with_from(options = {}, response_status = {})
		from = params[:from] || session[:from]
		if from
			redirect_to from, response_status
		else
			redirect_to options, response_status
		end
	end
end
