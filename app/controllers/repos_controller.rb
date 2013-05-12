class ReposController < ApplicationController
	skip_before_filter :require_login, only: [:access]

	def access
		user = User.find_by_uid params['user']
		repo = Repo.find_by_virtual_path params['path']
		access = params['access'].to_sym
		if user.nil? || repo.nil? || !repo.can_access?(user, access)
			render nothing: true, status: :forbidden
		else
			render text: repo.real_path
		end
	end
end
