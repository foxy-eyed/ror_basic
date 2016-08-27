class Station
  include InstanceCounter

  NAME_PATTERN = /^[[:alpha:]]{1}[[:print:]]{2,19}$/

  @@stations = {}

  attr_reader :name, :trains

  def self.find(name)
    @@stations[name.to_sym]
  end

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    @@stations[name.to_sym] = self
  end

  def valid?
    validate!
  rescue
    false
  end

  def let_in(train)
    trains << train
  end

  def let_out(train)
    trains.delete(train)
  end

  def show_trains_by_type(type)
    trains_by_type = []
    trains.each { |train| trains_by_type.push(train) if train.type == type }
    trains_by_type
  end

  def each_train
    trains.each { |train| yield(train) }
  end

  def to_s
    name.to_s
  end

  protected

  def validate!
    if NAME_PATTERN.match(name).nil?
      raise "Название должно начинаться с буквы, длина 3..20!"
    end
    raise "Станция с таким именем уже есть" if @@stations.key?(name.to_sym)
  end
end
