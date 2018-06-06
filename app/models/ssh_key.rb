class SshKey < ActiveRecord::Base
	YAPROM_SSH = File.join Rails.root, 'script', 'yaprom-ssh.rb'

	belongs_to :user
	attr_accessible :base64, :comment, :fingerprint, :size, :key_type

	after_create do
		SidekiqTask::GitTask::DeployKey.perform_async self.authorized_key
	end

	after_destroy do
		SidekiqTask::GitTask::UndeployKey.perform_async self.ref
	end

	class InvalidSshKeyException < Exception
		def initialize message = 'Invalid SSH key'
			super message
		end
	end

	def ref
		"~#{self.user.id}-#{self.id}"
	end

	def command
		"command=\"#{YAPROM_SSH} #{self.user.uid}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty"
	end

	def authorized_key
		"#{self.command} #{self.key_type} #{self.base64} #{self.ref}"
	end

	def self.parse_key data
		key = self.new

		chunk = data.split /\s+/
		key.key_type = chunk[0]
		key.base64 = chunk[1]
		key.comment = chunk[2]

		k = Net::SSH::KeyFactory.load_data_public_key(data)
		key.fingerprint = k.fingerprint
		key.size = case k
					   when OpenSSL::PKey::RSA
						   k.params['n'].num_bits
					   when OpenSSL::PKey::DSA
						   k.params['p'].num_bits
					   when OpenSSL::PKey::EC
						   k.group.degree
					   else
						   raise InvalidSshKeyException, 'Unknow SSH key type (supported: RSA, DSA, ECDSA)'
				   end

		key
	rescue => e
		raise InvalidSshKeyException, e
	end

	def self.create user, content
		key = self.parse_key content
		key.user = user
		key.save
		user.ssh_keys << key
		key
	end
end
