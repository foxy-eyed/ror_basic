class Train
  TYPE = {passenger: "пассажирский", cargo: "грузовой"}

  attr_accessor :speed, :wagons_count
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

  def to_s
    puts "поезд №#{self.number}: #{TYPE[self.type]}, вагонов — #{self.wagons_count}, скорость — #{self.speed}"
  end
end
