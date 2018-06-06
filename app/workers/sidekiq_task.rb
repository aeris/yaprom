require 'grit'

class SidekiqTask
	include Sidekiq::Worker

	class GitTask < SidekiqTask
		sidekiq_options queue: :git

		AUTHORIZED_KEYS = File.expand_path YamlConfig['git.authorized_keys']
		FileUtils.mkdir_p GitRepo::DIRECTORY unless File.directory? GitRepo::DIRECTORY

		class InitRepository < GitTask
			def perform id
				repo = GitRepo.find id
				origin = repo.origin
				if origin.nil?
					Grit::Repo.init_bare repo.real_path
				else
					src = origin.real_path
					dst = repo.real_path
					Grit::Repo.new(src).fork_bare dst
				end
			end
		end

		class DeployKey < GitTask
			def perform key
				open(AUTHORIZED_KEYS, 'a') do |f|
					f.puts key
				end
			end
		end

		class UndeployKey < GitTask
			def perform ref
				system 'sed', '-i', "/\\s#{ref}$/d", AUTHORIZED_KEYS
			end
		end
	end
end
