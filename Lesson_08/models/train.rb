class Train
  include Vendor
  include InstanceCounter
  
  TYPE = {passenger: "Пассажирские", cargo: "Грузовые"}
  NUMBER_PATTERN = /^[[:alnum:]]{3}[-]?[[:alnum:]]{2}$/

  @@trains = {}

  attr_reader :number, :type, :speed, :route, :current_station, :wagons, :wagons_count

  def self.find(number)
    @@trains[number.to_sym]
  end

  def self.list
    @@trains
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    @wagons_count = 0
    validate!
    register_instance
    @@trains[number.to_sym] = self
  end

  def is_valid?
    validate!
  rescue
    false
  end

  def attach_wagon(wagon)
    raise "Нельзя прицепить вагон на ходу!" unless self.speed.zero?
    unless wagon.match?(self) || self.wagons.include?(wagon)
      raise "Тип вагона не соответствует или он уже прицеплен!"
    end
    attach_wagon!(wagon)
  end

  def detach_wagon
    raise "Нельзя отцепить вагон на ходу!" unless self.speed.zero?
    raise "У позда нет вагонов!" if self.wagons_count.zero?
    wagon = self.wagons.last
    detach_wagon!(wagon)
  end

  def set_route(route)
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
    raise "Поезду не назначен маршрут!" if self.route.nil?
    new_station = direction == :back ? prev_station : next_station
    raise "Поезд на конечной станции!" if new_station.nil?
    go!(new_station)
  end

  def locate
    location = {
      route: self.route,
      current: self.current_station,
      prev: prev_station,
      next: next_station
    }
  end

  def to_s
    "Поезд №#{self.number}: тип — #{TYPE[self.type]}, вагонов — #{self.wagons_count}"
  end

  def each_wagon_with_index(block)
    self.wagons.each_with_index(&block)
  end

  # этого метода изначально не было,
  # добавлен для перемещния без маршрута
  # (чисто для демонстрации текстового интерфейса в усл. задании)
  def teleport!(station)
    relocation = {}
    if self.current_station
      relocation[:from] = self.current_station
      self.current_station.let_out(self)
    end
    self.current_station = relocation[:to] = station
    relocation
  end

  protected

  def validate!
    raise "Недопустимый формат номера!" if NUMBER_PATTERN.match(self.number).nil?
    raise "Поезд с таким номером уже есть!" if @@trains.key?(self.number.to_sym)
    true
  end

  private

  def go!(new_station)
    self.current_station.let_out(self)
    speed_up(70)
    self.current_station = new_station
    stop
  end

  def current_station=(station)
    station.let_in(self)
    @current_station = station
  end

  def wagons_count=(count)
    @wagons_count = count
  end

  def attach_wagon!(wagon)
    self.wagons << wagon
    self.wagons_count += 1
  end

  def detach_wagon!(wagon)
    self.wagons.delete(wagon)
    self.wagons_count -= 1
  end

  def speed_up(value)
    @speed = value
  end

  def stop
    @speed = 0
  end
end
