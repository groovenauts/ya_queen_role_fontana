# -*- coding: utf-8 -*-
require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class Asset < YaQueen::Base

    def implement_each_task(host, options)
      role :web, host
      role :asset, host
      super
    end

    def implement_common_task
      set :user,       config['user']
      set :deploy_to,  config['deploy_to']

      # デプロイと言っても通常のdeployの仕組みは使わないので、この辺の設定は不要
      # set :scm, :none
      # set :repository, File.expand_path("../../", File.dirname(__FILE__))

      unless defined?(::Rails)

        m = Module.new do
          def self.root
            unless @root
              @root = Object.new
              def @root.join(path)
                File.join(File.expand_path("../../..", __FILE__), path)
              end
            end
            @root
          end
        end
        Object.const_set(:Rails, m)
      end

      path = Rails.root.join("config/asset_drivers.yml.erb").to_s
      asset_drivers_config = YAML.load(ERB.new(File.read( path )).result)
      set :deploy_from, asset_drivers_config["file"]["file_path"]

      super
    end

  end
end
