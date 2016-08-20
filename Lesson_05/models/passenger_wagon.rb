require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize 
    @type = :passenger
  end
end
