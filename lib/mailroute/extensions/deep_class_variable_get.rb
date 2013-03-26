module Mailroute
  module DeepClassVariableGet
    def self.included(base)
      base.extend ClassMethods
      base.instance_variable_set(:@_deep_root, true)
    end

    module ClassMethods
      def deep_class_variable_get(var)
        val = instance_variable_get(var)
        if val || @_deep_root
          val
        else
          superclass.deep_class_variable_get(var)
        end
      end
    end
  end
end