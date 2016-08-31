module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def validate(name, validator, options = nil)
      rules[name] = rules.key?(name) ? rules[name].dup : {}
      rules[name][validator] = [options].compact
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
      self.class.rules.each do |name, rules|
        value = instance_variable_get("@#{name}")
        rules.each { |validator, options| send(validator, name, value, *options) }
      end
    end

    def presence(name, val)
      raise "Атрибут #{name} обязателен!" if val.nil? || val.empty?
    end

    def format(name, val, pattern)
      raise "Недопустимый формат #{name}!" if pattern.match(val).nil?
    end

    def type(name, val, type)
      raise "Атрибут #{name} должен иметь тип #{type}!" unless val.is_a?(type)
    end

    def positive_number(name, val)
      raise "Атрибут #{name} должен быть больше нуля!" unless val > 0
    end
  end
end
