class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def let_in(train)
    train.stop
    self.trains << train
  end

  def let_out(train)
    train.speed_up(10)
    self.trains.delete(train)
  end

  def show_trains_by_type(type)
    trains_by_type = []
    self.trains.each { |train| trains_by_type.push(train) if train.type == type }
    
    if trains_by_type.empty?
      puts "#{Train::TYPE[type]} поезда на станции «#{self}» отсутствуют."
    else
      puts "#{Train::TYPE[type]} поезда на станции «#{self}» — #{trains_by_type.size} шт.:"
      puts trains_by_type
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

end
