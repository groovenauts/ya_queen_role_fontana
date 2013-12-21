# -*- coding: utf-8 -*-
require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class GotoolSandbox < YaQueen::Base

    def implement_common_task
      set :user, config['user']
      set :scm,            :git
      set :scm_verbose,    true
      # set :repository,     config["repository"] # deploy.rbかステージファイルで指定される
      set :default_branch, "master"

      set :branch do
        tag = Capistrano::CLI.ui.ask "branch or tag : [#{default_branch}] "
        tag = default_branch if tag.empty?
        tag
      end

      # deploy
      set :deploy_via,     :copy
      ## :deploy_to は初期値として { "/u/apps/#{application}" } が入っているので、
      ##   -s deploy_to 指定時はオプションの値、省略時は deploy_config (yaml) の値、
      ## という指定方法ができない。-s で指定する場合は -s override_deploy_to で指定することにする
      set :deploy_to,      fetch(:override_deploy_to, config['deploy_to'])
      set :deploy_env,     "production"
      set :rails_env,      "production"

      # workspaces
      # DEPRECATED use :workspaces instead of these
      set :workspaces_scm    , config["workspaces"]["scm"]
      set :workspaces_runtime, config["workspaces"]["runtime"]
      set :workspaces, config["workspaces"]

      ## newrelic
      if config.has_key?('newrelic')
        set :newrelic_license_key,     config['newrelic']['license_key']      unless exists?(:newrelic_license_key)
        set :newrelic_agent_enabled,   config['newrelic']['agent_enabled']    unless exists?(:newrelic_agent_enabled)
        set :newrelic_app_name,        config['newrelic']['app_name']         unless exists?(:newrelic_app_name)
      end

      super
    end

    def implement_each_task(host, options)
      domain = fetch(:domain, host)
      role :web, domain
      role :app, domain
      role :db , domain, :primary => true
      role :gotool, domain
      super
    end

  end
end
