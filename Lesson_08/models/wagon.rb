class Wagon
  include Vendor
  
  DIMENSIONS = {passenger: "количество мест", cargo: "объём"}

  attr_reader :capacity, :type, :occupied

  def self.dimension(type)
    DIMENSIONS[type]
  end

  def initialize(capacity)
    @occupied = 0
    validate!
  end

  def match?(train)
    self.type == train.type
  end

  def available
    self.capacity - self.occupied
  end

  def available?(required)
    self.available >= required
  end

  def is_valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise "Вместимость должна быть больше нуля!" unless self.capacity > 0
  end
end
