require "ya_queen_role_fontana"

require "ya_queen"

module YaQueenRoleFontana
  class Config < YaQueen::Config

    def role(name, options = {})
      if options && (class_name = options.delete(:class_name))
        options[:class] = const_get(class_name.to_sym)
      end
      define_server_tasks(name, options)
    end
  end
end
