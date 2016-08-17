class Route
  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]
  end

  def include(station)
    if !self.stations.include?(station)
      self.stations.insert(-2, station)
      puts "Станция «#{station}» добавлена в маршрут #{self}."
    else
      puts "Станция уже добавлена в маршрут ранее."
    end
  end

  def exclude(station)
    if self.stations.include?(station)
      if station != self.stations.first && station != self.stations.last
        self.stations.delete(station)
        puts "Станция «#{station}» удалена из маршрута #{self}"
      else
        puts "Нельзя удалить начальную и конечную точку маршрута."
      end
    else
      puts "Станция не найдена в маршруте."
    end
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
    puts "Маршрут #{self}: "
    self.stations.each_with_index { |station, i| puts "#{i + 1}. #{station}" }
  end

  def to_s
    "«#{self.stations.first} — #{self.stations.last}»"
  end
  
end
