class Project < ActiveRecord::Base
	acts_as_superclass

	attr_accessible :name, :uid, :description, :scm, :private, :public
	belongs_to :owner, class_name: User

	validates :name, length: {minimum: 5}, presence: true, uniqueness: true
	validates :uid, format: {with: /\A[a-z0-9-]+\z/}, length: {minimum: 5}, presence: true, uniqueness: true

	def self.real_class(scm)
		case scm
			when :git then GitProject
			when :svn then SvnProject
		end
	end

	def public=(public)
		self.private = !public
	end

	def public?
		!self.private?
	end
end
