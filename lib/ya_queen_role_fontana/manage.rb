# -*- coding: utf-8 -*-
require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class Manage < YaQueen::Base

    def define_role_task
      define_manage_apisrv_task
      define_manage_gotool_task
    end

    def define_manage_apisrv_task
      t = self
      config = self.config
      ## [ローカルPC->管理用サーバ] ローカルPCから、管理用サーバに ApiSrv としてデプロイするためのタスク
      task :"@manage/apisrv" do
        set :deploy_to,  config['apisrv']['deploy_to']
        set :gemfile_name, "ApiServer"
        ## deploy:assets:precompile をさせない
        ## assets_role を空にするだけでは no matching servers でエラーになる。HOSTFILTERをつけることで no matching servers でも先に進めるようになる。
        set :assets_role, []
        ENV['HOSTFILTER'] = config['server']
        ## manage/apisrv 以外と混ざらないようにする
        t.set_deploy_target current_task.name
      end
      after :"@manage/apisrv", :"@manage/common"
    end

    def define_manage_gotool_task
      t = self
      config = self.config
      ## [ローカルPC->管理用サーバ] ローカルPCから、管理用サーバに GOTool としてデプロイするためのタスク
      task :"@manage/gotool" do
        set :deploy_to,  config['gotool']['deploy_to']
        set :gemfile_name, "GOTool"
        ## manage/apisrv 以外と混ざらないようにする
        t.set_deploy_target current_task.name
      end
      after :"@manage/gotool", :"@manage/common"
    end

    def define_each_tasks
      # do nothing
    end

    def define_common_task
      t = self
      config = self.config
      task :"@manage/common" do
        set :user, config['user']
        set :scm,            :git
        # set :scm_verbose,    true
        # set :repository,     config["repository"] # deploy.rbかステージファイルで指定される

        set :default_branch, "master"
        set :branch do
          tag = Capistrano::CLI.ui.ask "branch or tag : [#{default_branch}] "
          tag = default_branch if tag.empty?
          tag
        end

        role :web, config['server']
        role :app, config['server']
        #role :db , config['server'], :primary => true
        role :management, config['server']

        # mongoid.yml のテンプレート
        # .erbが設定されている場合は、config/mongoid.ymlをこのテンプレートから生成します。
        set :mongoid_yml_template, "config/mongoid.yml.production.erb"
        set :tengine_servers, t.root['tengine']['servers']
      end
    end

  end
end
