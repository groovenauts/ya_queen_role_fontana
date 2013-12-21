require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class TitleAppProduction < YaQueen::Base

    def implement_common_task
      set :user, config['user']
      set :deploy_to, fetch(:override_deploy_to, config['deploy_to'])
      super
    end

    def implement_each_task(host, options)
      role :app, host
      role :title_app, host
      super
    end

  end
end
