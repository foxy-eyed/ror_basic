class Train
  include Vendor
  include InstanceCounter

  TYPE = { passenger: "Пассажирские", cargo: "Грузовые" }.freeze
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

  def valid?
    validate!
  rescue
    false
  end

  def attach_wagon(wagon)
    raise "Нельзя прицепить вагон на ходу!" unless speed.zero?
    unless wagon.match?(self) || wagons.include?(wagon)
      raise "Тип вагона не соответствует или он уже прицеплен!"
    end
    attach_wagon!(wagon)
  end

  def detach_wagon
    raise "Нельзя отцепить вагон на ходу!" unless speed.zero?
    raise "У позда нет вагонов!" if wagons_count.zero?
    wagon = wagons.last
    detach_wagon!(wagon)
  end

  def route=(route)
    current_station.let_out(self) if current_station
    @route = route
    self.current_station = route.stations.first
  end

  def next_station
    route.next(current_station)
  end

  def prev_station
    route.prev(current_station)
  end

  def go(direction = :forward)
    raise "Поезду не назначен маршрут!" if route.nil?
    new_station = direction == :back ? prev_station : next_station
    raise "Поезд на конечной станции!" if new_station.nil?
    go!(new_station)
  end

  def locate
    {
      route: route,
      current: current_station,
      prev: prev_station,
      next: next_station
    }
  end

  def to_s
    "Поезд №#{number}: тип — #{TYPE[type]}, вагонов — #{wagons_count}"
  end

  def each_wagon_with_index(block)
    wagons.each_with_index(&block)
  end

  # method added to use without route object
  def teleport!(station)
    relocation = {}
    if current_station
      relocation[:from] = current_station
      current_station.let_out(self)
    end
    self.current_station = relocation[:to] = station
    relocation
  end

  protected

  def validate!
    raise "Недопустимый формат номера!" if NUMBER_PATTERN.match(number).nil?
    raise "Поезд с таким номером уже есть!" if @@trains.key?(number.to_sym)
    true
  end

  private

  def go!(new_station)
    current_station.let_out(self)
    speed_up(70)
    self.current_station = new_station
    stop
  end

  def current_station=(station)
    station.let_in(self)
    @current_station = station
  end

  attr_writer :wagons_count

  def attach_wagon!(wagon)
    wagons << wagon
    self.wagons_count += 1
  end

  def detach_wagon!(wagon)
    wagons.delete(wagon)
    self.wagons_count -= 1
  end

  def speed_up(value)
    @speed = value
  end

  def stop
    @speed = 0
  end
end
