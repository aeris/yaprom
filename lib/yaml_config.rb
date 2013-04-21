class YamlConfig
	@@yaml = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

	def self.[] param
		yaml = @@yaml
		param.split(/\./).each { |p| break unless yaml = yaml[p] }
		return yaml
	end
end
