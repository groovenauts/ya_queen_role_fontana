require "ya_queen_role_fontana/version"

module YaQueenRoleFontana
  autoload :Config, "ya_queen_role_fontana/config"

  # fontana application roles
  autoload :ConfigsrvProduction, "ya_queen_role_fontana/configsrv_production"
  autoload :ConfigsrvSandbox   , "ya_queen_role_fontana/configsrv_sandbox"

  autoload :TitleAppProduction , "ya_queen_role_fontana/title_app_production"
  autoload :TitleAppSandbox    , "ya_queen_role_fontana/title_app_sandbox"

  # fontana server roles
  autoload :GotoolProduction, "ya_queen_role_fontana/gotool_production"
  autoload :GotoolSandbox   , "ya_queen_role_fontana/gotool_sandbox"

  autoload :Manage  , "ya_queen_role_fontana/manage"  # production only
  autoload :Apisrv  , "ya_queen_role_fontana/apisrv"  # production only
  autoload :Asset   , "ya_queen_role_fontana/asset"   # production only
  autoload :Mongo   , "ya_queen_role_fontana/mongo"   # production only
  autoload :Tengine , "ya_queen_role_fontana/tengine" # production only

end
