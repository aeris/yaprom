class AuthProvider
	def create(user, password)
	end

	def change_password(user, password)
	end

	class DatabaseProvider < AuthProvider
		def authenticate(uid, password)
			User.where(uid: uid, password: User.hash_password(password)).first
		end
	end

	class LdapProvider < AuthProvider
		def initialize(params)
			@params = params
		end

		def create(user, password)
			ldap = Net::LDAP.new @params[:ldap]
			ldap.auth *@params[:auth]
			ldap.open do |l|
				l.add dn: @params[:uid] % {uid: user.uid},
					  attributes: {objectclass: %w(top inetorgperson),
								   uid: user.uid, cn: user.common_name, sn: user.surname,
								   userpassword: Net::LDAP::Password.generate(:sha, password)}
			end
		end

		def authenticate(uid, password)
			ldap = Net::LDAP.new @params[:ldap]
			ldap.auth @params[:uid] % {uid: uid}, password
			ldap.bind ? User.find_by_uid(uid) : nil
		end

		def change_password(user, old_password, new_password)
			ldap = Net::LDAP.new @params[:ldap]
			dn = @params[:uid] % {uid: user.uid}
			ldap.auth dn, old_password
			ldap.open do |l|
				l.replace_attribute dn, :userpassword, Net::LDAP::Password.generate(:sha, new_password)
			end
		end
	end
end
