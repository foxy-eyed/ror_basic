module InstanceCounter
  
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    @instances = 0

    def instances
      @instances ||= 0
    end

    private
    def increase_instance_count
      @instances = self.instances + 1
    end
  end

  module InstanceMethods
    private
    def register_instance
      self.class.send(:increase_instance_count)
    end
  end
end
