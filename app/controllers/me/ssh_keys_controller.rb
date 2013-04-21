class Me::SshKeysController < ApplicationController
	def new
		@content = ''
	end

	def create
		@content = params[:ssh_key_content]
		if @content.empty?
			file = params[:ssh_key_file]
			@content = file.read if file
		end
		SshKey.create @me, @content
		flash[:success] = 'SSH key created successfully'
		redirect_to_with_from me_path
	rescue Exception => e
		flash[:error] = e.message
		render :new
	end

	def destroy
		ssh_key = SshKey.find params[:id]
		if ssh_key.user != @me
			flash[:error] = 'This key is not one of yours'
		else
			ssh_key.destroy
			flash[:success] = 'SSH key deleted successfully'
		end
		redirect_to_with_from me_path
	end
end
