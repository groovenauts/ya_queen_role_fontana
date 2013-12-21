# -*- coding: utf-8 -*-
require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class ConfigsrvSandbox < YaQueen::Base

    def implement_common_task
      set :user, config['user']
      set :scm,            :git
      set :scm_verbose,    true
      if repo = config["repository"]
        set :repository, repo
      end
      # set :branch, "app_releases"

      # deploy
      set :deploy_via,     :copy
      ## :deploy_to は初期値として { "/u/apps/#{application}" } が入っているので、
      ##   -s deploy_to 指定時はオプションの値、省略時は deploy_config (yaml) の値、
      ## という指定方法ができない。-s で指定する場合は -s override_deploy_to で指定することにする
      set :deploy_to,      fetch(:override_deploy_to, config['deploy_to'])
      set :deploy_env,     "production"
      set :rails_env,      "production"

      # Configサーバ
      set :config_server_path,       fetch(:config_server_path,          config['path'])
      set :config_server_repository, fetch(:config_server_repository,    config['repository'])
      set :config_server_branch,     fetch(:config_server_branch,        config['branch'])

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
