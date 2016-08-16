class Train
  TYPE = {passenger: "Пассажирские", cargo: "Грузовые"}

  attr_accessor :speed, :route
  attr_reader :number, :type, :current_station

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
  end

  def speed_up(value)
    self.speed += value
  end

  def stop
    self.speed = 0
  end

  def attach_wagon(wagon)
    #attach wagon if it is match and speed is 0 
  end

  def detach_wagon(wagon)
    #detach wagon if it is not the last and speed is 0 
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
        self.current_station = new_station
      else 
        puts "Поезд на конечной станции, можно перемещаться только в другую сторону!"
      end
    else 
      puts "Поезду не назначен маршрут!"
    end
  end

  def locate
    if self.route
      puts "Поезд идет по маршруту #{self.route}."
      puts "Текущая станция — #{self.current_station}."
      puts "Предыдущая станция — #{self.prev_station}." if self.prev_station
      puts "Следующая станция — #{self.next_station}." if self.next_station
    else 
      puts "Поезду не назначен маршрут!"
    end
  end

  def info
    puts "Тип: #{TYPE[self.type]}, скорость: #{self.speed}"
  end

  def to_s
    "Поезд №#{self.number}"
  end

  private

  def current_station=(station)
    station.let_in(self)
    @current_station = station
  end

end
