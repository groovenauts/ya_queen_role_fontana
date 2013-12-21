# -*- coding: utf-8 -*-
require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class TitleAppSandbox < YaQueen::Base

    def implement_common_task
      set :user, config['user']
      set :scm,            :git
      if repo = config["repository"]
        set :repository, repo
      end
      set :scm_verbose,    true
      set :deploy_via,     :copy # Projectが生成するconfig/fontana.yml もコピーするので、copyが一番楽
      ## :deploy_to は初期値として { "/u/apps/#{application}" } が入っているので、
      ##   -s deploy_to 指定時はオプションの値、省略時は deploy_config (yaml) の値、
      ## という指定方法ができない。-s で指定する場合は -s override_deploy_to で指定することにする
      set :deploy_to      , fetch(:override_deploy_to, config['deploy_to'])
      set :copy_dir       , "/tmp/copy_dir"
      set :remote_copy_dir, "/tmp/remote_copy_dir"

      set :deploy_env,     "production"
      set :rails_env,      "production"
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
