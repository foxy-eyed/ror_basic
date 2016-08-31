module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def validate(name, validator, options = nil)
      key = "#{name}_#{validator}".to_sym
      rules[key] = { validator: validator, args: [name, options].compact }
    end

    def rules
      @rules ||= {}
    end

    def inherited(subclass)
      subclass.instance_variable_set(:@rules, rules.dup)
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
      self.class.rules.each do |_key, rule|
        value = instance_variable_get("@#{rule[:args].first}")
        send(rule[:validator], value, *rule[:args])
      end
    end

    def presence(val, name)
      raise "Атрибут #{name} обязателен!" if val.nil? || val.empty?
    end

    def format(val, name, pattern)
      raise "Недопустимый формат #{name}!" if pattern.match(val).nil?
    end

    def type(val, name, type)
      raise "Атрибут #{name} должен иметь тип #{type}!" unless val.is_a?(type)
    end

    def positive_number(val, name)
      raise "Атрибут #{name} должен быть больше нуля!" unless val > 0
    end
  end
end
