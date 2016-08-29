require_relative 'wagon'

class CargoWagon < Wagon
  def initialize(capacity)
    @type = :cargo
    @capacity = capacity.to_f
    super
  end

  def load(volume)
    raise "Недостаточно места!" unless available?(volume)
    @occupied += volume
  end

  def to_s
    "Грузовой вагон: занятый объём — #{occupied}, доступный — #{available}"
  end
end
