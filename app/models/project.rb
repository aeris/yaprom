class Project < ActiveRecord::Base
	attr_accessible :name, :uid, :description, :scm
	has_one :owner, as: User

	validates :name, length: { minimum: 5 }, presence: true, uniqueness: true
	validates :uid, format: { with: /\A[a-z0-9-]+\z/ }, length: { minimum: 5 }, presence: true, uniqueness: true
	validates :scm, inclusion: { in: %w(git svn) }, presence: true
end
