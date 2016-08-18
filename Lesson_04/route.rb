class Route
  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]
  end

  def include(station)
    if !in_route?(station)
      include!(station)
    else
      puts "Станция уже добавлена в маршрут ранее."
    end
  end

  def exclude(station)
    if in_route?(station)
      if not_endpoint?(station)
        exclude!(station)
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

  private 

  # Все методы, которые я сюда вынесла, 
  # были выделены из кода публичных методов, чтобы сделать их короче и читабельнее.

  def in_route?(station)
    self.stations.include?(station)
  end

  def not_endpoint?(station)
    station != self.stations.first && station != self.stations.last
  end
  
  # Поскольку все проверки остались в публичных методах include и exclude,
  # напрямой вызов этих методов д.б. невозможен, ибо чреват
  def include!(station)
    self.stations.insert(-2, station)
    puts "Станция «#{station}» добавлена в маршрут #{self}."
  end

  def exclude!(station)
    self.stations.delete(station)
    puts "Станция «#{station}» удалена из маршрута #{self}"
  end

end
