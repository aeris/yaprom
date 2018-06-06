#!/usr/bin/env ruby
require 'pathname'
require 'logger'
require 'net/http'
require 'json'
require 'yaml'

module Rails
	ENV = ::ENV['RAILS_ENV'] || 'production'
	ROOT = File.dirname Pathname.new(File.join(__FILE__, '..')).realpath

	def self.env
		Rails::ENV
	end

	def self.root
		ROOT
	end
end

require_relative '../lib/yaml_config'

class Parser
	REGEXP = /^(.+)\s+'\/?([a-z0-9.\-_\/]+)'$/.freeze
	WRITE_COMMANDS = %w(git-receive-pack)
	READ_COMMANDS = %w(git-upload-pack git-upload-archive)
	COMMANDS = READ_COMMANDS + WRITE_COMMANDS

	attr_reader :command, :path, :access

	def initialize(command)
		match = REGEXP.match command
		raise ArgumentError, :invalid_command if match.nil?

		@command = match[1]
		@path = match[2].sub(/(^\/|\/$)/, '')
		@access = case @command
					  when *READ_COMMANDS
						  :read
					  when *WRITE_COMMANDS
						  :write
					  else
						  raise ArgumentError, :unknow_command
				  end
	end
end

begin
	original_command = ENV['SSH_ORIGINAL_COMMAND']
	user = ARGV[0]

	logger = Logger.new File.join Rails.root, 'log', 'yaprom-ssh_auth.log'
	logger.formatter = Logger::Formatter.new
	logger.level = case Rails.env
					   when 'production'
						   Logger::INFO
					   else
						   Logger::DEBUG
				   end
	logger.formatter.datetime_format = '%m-%d-%Y %H:%M:%S'
	logger.info "Connection from #{ENV['SSH_CLIENT'].inspect} (#{user || nil}): #{original_command || nil}"

	logger.debug "original_command: #{original_command.inspect}"
	if original_command.nil? || original_command.strip.empty?
		$stderr.puts "Welcome, #{user}. Use git to push/pull your repositories"
		exit!(1)
	end

	parser = Parser.new original_command
	command = parser.command
	path = parser.path
	access = parser.access

	if user.nil? || user.empty?
		raise ArgumentError, 'Need user arg'
	end

	logger.debug "command: #{command}"
	logger.debug "repository: #{path}"
	logger.debug "command access need: #{access}"
	logger.debug "user: #{user}"

	uri = URI "#{YamlConfig['url']}/repos/access"
	uri.query = URI.encode_www_form({ user: user, path: path, access: access })
	response = Net::HTTP.get_response uri
	raise SecurityError, :not_enough_permissions unless response.is_a? Net::HTTPSuccess
	real_path = response.body
	logger.debug "real repository: #{real_path}"
	exec 'git-shell', '-c', "#{command} '#{real_path}'"
rescue Exception => e
	logger.error e.message unless logger.nil?
	$stderr.puts e.message
	exit! 1
end
