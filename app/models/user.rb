class User < ActiveRecord::Base
	attr_accessible :uid, :common_name, :surname, :password, :password_confirmation, :email, :admin
	has_many :projects, inverse_of: :owner
	has_many :ssh_keys

	validates :uid, format: { with: /\A[a-z]+\z/ }, presence: true, uniqueness: true
	validates :common_name, presence: true, format: { with: /\A[a-zA-Z\- ]+\z/ }
	validates :surname, presence: true, format: { with: /\A[a-zA-Z\- ]+\z/ }
	validates :email, presence: true, uniqueness: true
	validates :password, confirmation: true

	before_create do
		self.password = User.hash_password self.password
	end

	def self.generate_password(length = 10)
		SecureRandom.hex length
	end

	def self.hash_password(password)
		Digest::SHA512.hexdigest password
	end

	def check(password)
		self.password == User.hash_password(password)
	end
end
