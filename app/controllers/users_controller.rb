class UsersController < ApplicationController
	skip_before_filter :require_login , only: [:new, :create]

	def new
		@user = User.new
	end

	def create
		@user = User.new params[:user]
		if @user.save
			session[:me] = @user.id
			flash[:success] = 'User registered successfully'
			redirect_to me_path
		else
			render :new
		end
	end

	def find
		search = params[:find]
		render json: User.where("uid LIKE :search OR common_name LIKE :search or surname LIKE :search", search: "%#{search}%").
			collect { |u| {label: u.name, value: u.uid} }
	end
end
