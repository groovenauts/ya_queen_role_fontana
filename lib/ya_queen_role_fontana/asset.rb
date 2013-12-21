# -*- coding: utf-8 -*-
require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class Asset < YaQueen::Base

    class RailsRoot
      def initialize(root)
        @root = root
      end
      def join(path)
        File.join(@root, path)
      end
    end
    class Rails
      attr_reader :root
      def initialize(root)
        @root = RailsRoot.new(root)
      end
    end

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
      # set :repository, root_dir

      unless defined?(::Rails)
        Object.const_set(:Rails, YaQueenRoleFontana::Asset::Rails.new(root_dir))
      end

      path = Rails.root.join("config/asset_drivers.yml.erb").to_s
      asset_drivers_config = YAML.load(ERB.new(File.read( path )).result)
      set :deploy_from, asset_drivers_config["file"]["file_path"]

      super
    end

  end
end
