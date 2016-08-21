class Train
  include Vendor
  include InstanceCounter
  
  TYPE = {passenger: "Пассажирские", cargo: "Грузовые"}

  @@trains = {}

  attr_reader :number, :type, :speed, :route, :current_station, :wagons, :wagons_count

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    @wagons_count = 0
    @@trains[number] = self
    register_instance
  end

  def attach_wagon(wagon)
    if self.speed.zero?
      if wagon.match?(self) && !self.wagons.include?(wagon)
        attach_wagon!(wagon)
        puts "Вагон прицеплен! Стало вагонов: #{self.wagons_count}"
      else
        puts "Тип вагона не соответствует или он уже прицеплен!"
      end
    else 
      puts "Нельзя прицепить вагон на ходу!"
    end
  end

  def detach_wagon
    if self.speed.zero?
      wagon = self.wagons.last
      detach_wagon!(wagon)
      puts "Вагон отцеплен! Стало вагонов: #{self.wagons_count}"
    else 
      puts "Нельзя отцепить вагон на ходу!"
    end
  end

  def set_route(route)
    # уберем с текущей станции, если поезд уже на маршруте
    self.current_station.let_out(self) if self.current_station
    
    @route = route
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
        go!(new_station)
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

  # этого метода изначально не было,
  # добавлен для перемещния без маршрута
  # (чисто для демонстрации текстового интерфейса в усл. задании)
  def teleport!(station)
    self.current_station.let_out(self) if self.current_station
    self.current_station = station
  end

  private

  # вынесла фрагмент из метода go
  # для сокрытия деталей реализации
  def go!(new_station)
    self.current_station.let_out(self)
    speed_up(70)
    self.current_station = new_station
    stop
  end

  # нельзя указать текущую станцию напрямую извне!
  # она инициализируется при назначении маршрута (set_route),
  # а меняется только при перемещении по маршруту в методе go!
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
  # поэтому вызывается только внутри метода go!,
  # извне скорость утановить нельзя
  def speed_up(value)
    @speed = value
    puts "Поезд набрал скорость #{value} км/ч."
  end

  # по аналогии с предыдущим методом используется внутри go!
  def stop
    @speed = 0
    puts "Поезд остановился."
  end

end
