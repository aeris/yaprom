class Admin::SiteController < ApplicationController
	before_filter :require_admin

	def require_admin
		render :forbidden unless @me.admin?
	end

	def forbidden
	end

	def index
	end
end
