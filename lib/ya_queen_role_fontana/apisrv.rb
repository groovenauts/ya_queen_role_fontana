# -*- coding: utf-8 -*-
require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class Apisrv < YaQueen::Base

    def implement_each_task(host, options)
      role :web, host
      role :app, host
      role :apisrv, host
      ## deploy:assets:precompile をさせない
      ## assets_role を空にするだけでは no matching servers でエラーになる。HOSTFILTERをつけることで no matching servers でも先に進めるようになる。
      set :assets_role, []
      ENV['HOSTFILTER'] = ENV.has_key?('HOSTFILTER') ? ENV['HOSTFILTER'] + ",#{host}" : host
      super
    end

    def implement_common_task
      set :user,       config['user']
      set :deploy_to,  config['deploy_to']
      set :gemfile_name, "ApiServer"
      set :bundle_dir, "./vendor/bundle"
      set :bundle_without, [:development, :test, :deploy]
      set :scm, :none
      set :repository, root_dir

      set :workspaces, config["workspaces"]
      set :workspaces_scm    , config["workspaces"]["scm"]
      set :workspaces_runtime, config["workspaces"]["runtime"]

      if config.has_key?('newrelic')
        set :newrelic_license_key,     config['newrelic']['license_key']      unless exists?(:newrelic_license_key)
        set :newrelic_agent_enabled,   config['newrelic']['agent_enabled']    unless exists?(:newrelic_agent_enabled)
        set :newrelic_app_name,        config['newrelic']['app_name']         unless exists?(:newrelic_app_name)
      end

      # mongoid.yml のテンプレート
      # .erb以外が設定されている場合は、config/mongoid.ymlとしてこのファイル(の中身)をアップロードします。
      set :mongoid_yml_template, "config/mongoid.yml"

      super
    end

  end
end
