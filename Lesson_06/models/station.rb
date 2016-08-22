class Station
  include InstanceCounter
  
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

  def is_valid?
    validate!
  rescue
    false
  end

  def validate!
    raise "Название станции обязательно!" if self.name.empty?
    raise "Станция с таким именем уже есть" if @@stations.has_key?(self.name.to_sym)
    #todo regexp
  end

  def let_in(train)
    self.trains << train
    puts "Поезд прибыл на станцию «#{self}»."
  end

  def let_out(train)
    self.trains.delete(train)
    puts "Поезд отправился со станции «#{self}»."
  end

  def show_trains_by_type(type)
    selection = trains_by_type(type)
    if selection.empty?
      puts "#{Train::TYPE[type]} поезда на станции «#{self}» отсутствуют."
    else
      puts "#{Train::TYPE[type]} поезда на станции «#{self}» — #{selection.size} шт.:"
      puts selection
    end
  end

  def show_trains
    if self.trains.empty?
      puts "На станции «#{self}» поездов нет."
    else
      puts "На станции «#{self}» находятся поезда:"
      puts self.trains
    end
  end

  def to_s
    "#{self.name}"
  end

  private

  def trains_by_type(type)
    trains_by_type = []
    self.trains.each { |train| trains_by_type.push(train) if train.type == type }
    trains_by_type
  end

end
