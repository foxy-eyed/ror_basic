class Route
  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]
    validate!
  end

  def is_valid?
    validate!
  rescue
    false
  end

  def include(station)
    raise "Станция уже добавлена в маршрут ранее." if in_route?(station)
    include!(station)
  end

  def exclude(station)
    raise "Станция не найдена в маршруте." unless in_route?(station)
    raise "Нельзя удалить конечные станции маршрута." if endpoint?(station)
    exclude!(station)
  end

  def next(current)
    if current != self.stations.last
      self.stations.at(self.stations.index(current) + 1)
    end
  end

  def prev(current)
    if current != self.stations.first
      self.stations.at(self.stations.index(current) - 1)
    end
  end

  def list
    list = "Маршрут #{self}: "
    self.stations.each_with_index { |station, i| list += "#{i + 1}. #{station}" }
    list
  end

  def to_s
    "«#{self.stations.first} — #{self.stations.last}»"
  end

  protected

  def validate!
    self.stations.each_with_index do |station, i|
      raise "Объект #{i + 1} в маршруте не станция!" unless station.is_a?(Station)
    end
    true
  end

  private

  def in_route?(station)
    self.stations.include?(station)
  end

  def endpoint?(station)
    station == self.stations.first || station == self.stations.last
  end
  
  def include!(station)
    self.stations.insert(-2, station)
  end

  def exclude!(station)
    self.stations.delete(station)
  end

end
