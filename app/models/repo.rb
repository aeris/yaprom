class Repo < ActiveRecord::Base
	acts_as_superclass
	attr_accessible :uuid, :virtual_path

	before_create do
		self.uuid = SecureRandom.hex 10
	end
end
