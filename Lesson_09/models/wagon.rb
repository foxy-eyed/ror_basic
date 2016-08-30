class Wagon
  include Vendor
  include Validation

  DIMENSIONS = { passenger: "количество мест", cargo: "объём" }.freeze

  attr_reader :capacity, :type, :occupied

  validate :capacity, :positive_number

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
end
