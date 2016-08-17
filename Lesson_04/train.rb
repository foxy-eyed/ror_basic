class Train
  TYPE = {passenger: "Пассажирские", cargo: "Грузовые"}

  attr_accessor :route
  attr_reader :number, :type, :speed, :current_station, :wagons, :wagons_count

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    @wagons_count = 0
  end

  def attach_wagon(wagon)
    if self.speed.zero?
      if wagon.match?(self)
        if !self.wagons.include?(wagon)
          attach_wagon!(wagon)
        else
          puts "Мы уже прикрепили этот вагон ранее."
        end
      else
        puts "Тип вагона не соответствует типу поезда!"
      end
    else 
      puts "Нельзя прицепить вагон на ходу!"
    end
  end

  def detach_wagon(wagon)
    if self.speed.zero?
      if self.wagons.include?(wagon)
        detach_wagon!(wagon)
      else
        puts "Вагон не прицеплен к поезду!"
      end
    else 
      puts "Нельзя отцепить вагон на ходу!"
    end
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
      new_station = direction == :back ? prev_station : next_station
      if new_station
        self.current_station.let_out(self)
        speed_up(70)
        self.current_station = new_station
        stop
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
      puts "Предыдущая станция — #{prev_station}." if prev_station
      puts "Следующая станция — #{next_station}." if next_station
    else 
      puts "Поезду не назначен маршрут!"
    end
  end

  def info
    puts "Тип: #{TYPE[self.type]}, вагонов: #{self.wagons_count}"
  end

  def to_s
    "Поезд №#{self.number}"
  end

  private

  # нельзя указать текущую станцию напрямую извне!
  # она инициализируется при назначении маршрута (set_route),
  # а меняется только при перемещении по маршруту в методе go
  def current_station=(station)
    station.let_in(self)
    @current_station = station
  end

  # кол-во вагонов может изменяться только внутри методов
  # attach_wagon! и detach_wagon!
  # в результате успешного прикрепления/открепления вагона
  def wagons_count=(count)
    @wagons_count = count
  end

  # вызывается только из публичного метода attach_wagon
  # после прохождения всех необходимых проверок
  def attach_wagon!(wagon)
    self.wagons << wagon
    self.wagons_count += 1
  end

  # вызывается только из публичного метода detach_wagon
  # после прохождения всех необходимых проверок
  def detach_wagon!(wagon)
    self.wagons.delete(wagon)
    self.wagons_count -= 1
  end

  # поезд может набирать скорость только между станциями,
  # поэтому вызывается только внутри публичного метода go,
  # извне скорость утановить нельзя
  def speed_up(value)
    @speed = value
    puts "Поезд набрал скорость #{value} км/ч"
  end

  # по аналогии с предыдущим методом используется внутри go
  def stop
    @speed = 0
    puts "Поезд остановился."
  end

end
