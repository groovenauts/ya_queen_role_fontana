# -*- coding: utf-8 -*-
require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class Tengine < YaQueen::Base

    def implement_role_task
      set :user,          config['user']
      set :tengine_servers, config['servers']

      if replicasets = config['replicasets']
        set :replicasets, replicasets
        set :replicaset_names, replicasets.keys

        (replicasets || {}).each.with_index do |(name, rs), idx|
          role :"#{name}_primary", rs["primary"]
        end
      end

      if sharding = config['sharding']
        set :sharding, sharding
        role :sharding_workspace_host, sharding['workspace_host']
      end
    end

    def implement_each_task(host, options)
      role :tengine, host
      role :mongo, host
      super
    end

  end
end
