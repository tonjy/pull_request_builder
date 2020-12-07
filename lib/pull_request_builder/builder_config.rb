# frozen_string_literal: true

module PullRequestBuilder
  class BuilderConfig
    attr_accessor :octokit_client, :logger, :build_server,
                  :build_server_project_integration_prefix,
                  :build_server_project, :build_server_package_name,
                  :git_server, :git_repository, :git_branch
    
    attr_reader :osc

    def initialize(config = {})
      @git_server = config.fetch(:git_server, 'https://github.com')
      @build_server = config.fetch(:build_server, 'https://build.opensuse.org')
      Octokit.configure do |c|
        c.api_endpoint = @git_server + "/api/v3/"
      end
      @octokit_client = Octokit::Client.new(config[:credentials])
      @logger = config[:logging] ? Logger.new(STDOUT) : Logger.new(nil)
      @build_server_project = config.fetch(:build_server_project, 'OBS:Server:Unstable')
      @git_branch = config.fetch(:git_branch, 'master')
      @git_repository = config.fetch(:git_repository, 'openSUSE/open-build-service')
      @build_server_package_name = config.fetch(:build_server_package_name, 'obs-server')
      @build_server_project_integration_prefix = config.fetch(:build_server_project_integration_prefix,
                                                              'OBS:Server:Unstable:TestGithub:PR')
      @osc = OSC.new(@build_server, @logger)
    end

    def git_repository_full_address
      File.join(@git_server, @git_repository)
    end
  end
end
