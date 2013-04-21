class SshKey < ActiveRecord::Base
	belongs_to :user
	attr_accessible :base64, :comment, :fingerprint, :size, :key_type

	class InvalidSshKeyException < Exception
		def initialize message = 'Invalid SSH key'
			super message
		end
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
