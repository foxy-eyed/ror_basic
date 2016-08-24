require_relative 'train'

class PassengerTrain < Train
  def initialize(number)
    super
    @type = :passenger
  end
end
