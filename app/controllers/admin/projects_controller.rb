class Admin::ProjectsController < AdminController
	def create
		ActiveRecord::Base.transaction do
			owner = User.find_by_uid params[:project].delete :owner
			clazz = Project.real_class params[:project].delete(:scm).to_sym
			p clazz
			@project = clazz.new params[:project]
			@project.owner = owner
			if @project.save
				flash[:success] = 'Project created successfully'
				redirect_to admin_path
			end
		end
	end

end
