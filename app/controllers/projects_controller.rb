class ProjectsController < ApplicationController
	def new
		@project = Project.new
	end

	def create
		ActiveRecord::Base.transaction do
			owner = User.find_by_uid params[:project].delete :owner
			clazz = Project.real_class params[:project].delete(:scm).to_sym
			p clazz
			@project = clazz.new params[:project]
			@project.owner = owner
			if @project.save
				flash[:success] = 'Project created successfully'
				redirect_to project_path @project
			else
				render :new
			end
		end
	end

	def show
		@project = Project.find params[:id]
		case @project.scm
			when :git then render 'git_projects/show'
		end
	end

	def add_member
		project = Project.find params[:project_id]
		params[:members].split(',').each do |member|
			member = User.find_by_uid member
			project.add_member member
		end
		redirect_to project_path project
	end
end
