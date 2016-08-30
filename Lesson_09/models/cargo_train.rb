require_relative 'train'

class CargoTrain < Train
  CARGO_NUMBER_PATTERN = /^[[:alnum:]]{4}[-]{1}[[:alnum:]]{4}$/

  validate :number, :format, CARGO_NUMBER_PATTERN

  def initialize(number)
    super
    @type = :cargo
  end
end
