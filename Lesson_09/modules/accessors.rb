module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*args)
      args.each do |arg|
        var, var_get, var_set, history, history_get =
          ["@#{arg}", arg, "#{arg}=", "@#{arg}_history", "#{arg}_history"].map(&:to_sym)

        define_method(var_get) { instance_variable_get(var) }

        define_method(var_set) do |value|
          instance_variable_set(var, value)
          send(history_get) << value
        end

        define_method(history_get) do
          instance_variable_get(history) || instance_variable_set(history, [])
        end
      end
    end

    def strong_attr_accessor(var_name, var_class)
      var, var_get, var_set = ["@#{var_name}", var_name, "#{var_name}="].map(&:to_sym)

      define_method(var_get) { instance_variable_get(var) }

      define_method(var_set) do |value|
        unless value.is_a?(var_class)
          raise TypeError, "#{var_name} should be instance of #{var_class}!"
        end
        instance_variable_set(var, value)
      end
    end
  end
end
