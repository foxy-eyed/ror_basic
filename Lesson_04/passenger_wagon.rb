require_relative 'wagon.rb'

class PassengerWagon < Wagon
  def initialize 
    @type = :passenger
  end
end
