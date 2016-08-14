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

  def trains_by_type
    trains_by_type = {}
    self.trains.each do |train|
      trains_by_type[train.type] = [] unless trains_by_type.include?(train.type)
      trains_by_type[train.type].push(train)
    end
    trains_by_type
  end

  def show_trains_by_type
    puts "На станции #{self.name} находятся поезда: "
    self.trains_by_type.each do |type, trains|
      puts "#{Train::TYPE[type]} — #{trains.size} шт.:"
      puts trains
    end
  end

  def show_trains
    puts "На станции #{self.name} находятся поезда:"
    puts self.trains
  end

end
