require_relative 'wagon.rb'

class CargoWagon < Wagon
  def initialize 
    @type = :cargo
  end
end
