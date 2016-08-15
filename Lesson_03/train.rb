class Train
  TYPE = {passenger: "пассажирский", cargo: "грузовой"}

  attr_accessor :speed, :wagons_count, :route, :current_station
  attr_reader :number, :type

  def initialize(number, type, wagons_count)
    @number = number
    @type = type
    @wagons_count = wagons_count
    @speed = 0
  end

  def speed_up(value)
    self.speed += value
  end

  def stop
    self.speed = 0
  end

  def attach_wagon
    self.wagons_count += 1 if self.speed == 0 
  end

  def detach_wagon
    self.wagons_count -= 1 if self.speed == 0 && self.wagons_count > 0
  end

  def set_route(route)
    self.route = route
    self.current_station = route.stations.first
  end

  def next_station
    self.route.next(self.current_station)
  end

  def prev_station
    self.route.prev(self.current_station)
  end

  def go(direction = :forward)
    if self.route
      new_station = direction == :back ? self.prev_station : self.next_station
      if new_station
        self.current_station.let_out(self)
        new_station.let_in(self)
        self.current_station = new_station
      else 
        puts "Поезд на конечной станции, можно перемещаться только в другую сторону!"
      end
    else 
      puts "Поезду не назначен маршрут!"
    end
  end

  def to_s
    "поезд №#{self.number}: #{TYPE[self.type]}, вагонов — #{self.wagons_count}, скорость — #{self.speed}"
  end
end
