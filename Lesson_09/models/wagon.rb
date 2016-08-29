class Wagon
  include Vendor

  DIMENSIONS = { passenger: "количество мест", cargo: "объём" }.freeze

  attr_reader :capacity, :type, :occupied

  def self.dimension(type)
    DIMENSIONS[type]
  end

  def initialize(_)
    @occupied = 0
    validate!
  end

  def match?(train)
    type == train.type
  end

  def available
    capacity - occupied
  end

  def available?(required)
    available >= required
  end

  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise "Вместимость должна быть больше нуля!" unless capacity > 0
  end
end
