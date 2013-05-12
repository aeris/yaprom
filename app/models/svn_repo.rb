class SvnRepo < ActiveRecord::Base
	inherits_from :repo, methods: true
	belongs_to :project, class_name: SvnProject
end
