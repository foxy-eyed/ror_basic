require_relative 'train.rb'

class PassengerTrain < Train
  def initialize(number)
    super
    @type = :passenger
  end
end
