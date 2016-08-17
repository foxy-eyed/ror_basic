class Wagon
  attr_reader :type

  def match?(train)
    self.type == train.type
  end
  
end
