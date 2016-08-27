require_relative 'train'

class CargoTrain < Train
  def initialize(number)
    super
    @type = :cargo
  end
end
