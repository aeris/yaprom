class AuthProvider
	class DatabaseProvider < AuthProvider
		def authenticate user, password
			user.password == Digest::SHA256.hexdigest(password)
		end
	end

	class LdapProvider < AuthProvider
		def initialize params
			@params = params

		end

		def create user, password
			ldap = Net::LDAP.new @params[:ldap]
			ldap.auth *@params[:admin_auth]
			ldap.open do |l|
				l.add dn: @params[:user_dn] % {uid: user.uid},
					  attributes: {objectclass: [:top, :inetorgpersonn],
								   uid: user.uid, cn: '', sn: '',
								   userpassword: Net::LDAP::Password.generate(:sha, password)}
			end
		end

		def authenticate user, password
			ldap = Net::LDAP.new @params[:ldap]
			ldap.auth @params[:user_dn] % {uid: user.uid}, password
			ldap.bind
		end
	end

	def create user
	end
end
