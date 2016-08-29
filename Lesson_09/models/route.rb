class Route
  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]
    validate!
  end

  def valid?
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
    stations.at(stations.index(current) + 1) if current != stations.last
  end

  def prev(current)
    stations.at(stations.index(current) - 1) if current != stations.first
  end

  def list
    list = "Маршрут #{self}: "
    stations.each_with_index { |station, i| list += "#{i + 1}. #{station}" }
    list
  end

  def to_s
    "«#{stations.first} — #{stations.last}»"
  end

  protected

  def validate!
    stations.each_with_index do |station, i|
      raise "Объект #{i + 1} в маршруте не станция!" unless station.is_a?(Station)
    end
    true
  end

  private

  def in_route?(station)
    stations.include?(station)
  end

  def endpoint?(station)
    station == stations.first || station == stations.last
  end

  def include!(station)
    stations.insert(-2, station)
  end

  def exclude!(station)
    stations.delete(station)
  end
end
