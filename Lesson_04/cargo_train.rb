require_relative 'train.rb'

class CargoTrain < Train
  def initialize(number)
    super
    @type = :cargo
  end
end
