module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def validate(name, validator, options = nil)
      self.rules << {var: name, validator: validator, options: options}
    end

    def rules
      @rules ||= []
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue
      false
    end

    protected

    def validate!
      self.class.rules.each do |rule|
        send(rule[:validator], rule[:var], rule[:options])
      end
    end

    def get_val(name)
      instance_variable_get("@#{name}")
    end

    def presence(name)
      raise "Атрибут #{name} обязателен!" if get_val(name).nil? || get_val(name).empty?
    end

    def format(name, pattern)
      raise "Недопустимый формат #{name}!" if pattern.match(get_val(name)).nil?
    end

    def type(name, type)
      raise "Атрибут #{name} должен иметь тип #{type}!" unless get_val(name).is_a?(type)
    end

    def positive_number(name)
      raise "Атрибут #{name} должен быть больше нуля!" unless get_val(name).positive?
    end
  end
end
