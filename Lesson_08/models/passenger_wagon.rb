require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(capacity)
    @type = :passenger
    @capacity = capacity.to_i
    super
  end

  def take_a_seat
    raise "Свободных мест нет!" unless self.available?(1)
    @occupied += 1
  end

  def to_s
    "Пассажирский вагон: занято мест — #{self.occupied}, свободно — #{self.available}"
  end
end
