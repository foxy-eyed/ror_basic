class Controller
  BORDER = "---" * 12;

  def init(data)
    data[:stations].each { |name| create_station!(name) }
    
    data[:trains].each do |item| 
      train = create_train!(item[:type], item[:number])
      item[:wagons_count].times do
        attach_wagon!(train, item[:wagons_capacity])
      end
      random_station = Station.find(data[:stations][rand(data[:stations].size)])
      train.teleport!(random_station)
    end
  end

  def show_actions
    puts BORDER;
    puts "Для выбора действия введите его порядковый номер: "
    puts "[1] > Создать станцию"
    puts "[2] > Создать поезд"
    puts "[3] > Добавить к поезду вагон"
    puts "[4] > Отцепить вагон от поезда"
    puts "[5] > Поместить поезд на станцию"
    puts "[6] > Посмотреть список станций"
    puts "[7] > Посмотреть список поездов на станции"
    puts "[8] > Посмотреть список вагонов поезда"
    puts "[9] > Загрузить вагон"
    puts BORDER;
    puts "Дерево объектов: all  |  Выход: exit"
    puts BORDER;
  end

  def run_action(action)
    case action
    when "1"
      run(:create_station, true)
    when "2"
      run(:create_train, true)
    when "3"
      run(:attach_wagon)
    when "4"
      run(:detach_wagon)
    when "5"
      run(:go_to_station)
    when "6"
      run(:list_stations)
    when "7"
      run(:list_trains_on_station)
    when "8"
      run(:list_wagons)
    when "9"
      run(:load_wagon)
    when "all"
      run(:display_all_objects)
    else
      puts "Неизвестная команда!"
    end
  end

  private

  def run(method, need_retry = false)
    self.send(method)
  rescue RuntimeError => e
    puts e.message
    retry if need_retry
  end

  # action #1
  def create_station
    print "Укажите название станции: "
    name = gets.chomp
    create_station!(name)
  end

  # action #2
  def create_train
    print "Укажите тип поезда ([1] > грузовой, [2] > пассажирский): "
    type = gets.chomp.to_i
    print "Введите номер поезда (XXX-XX или XXXXX): "
    number = gets.chomp
    create_train!(type, number)
  end

  # action #3
  def attach_wagon
    train = select_train
    print "Укажите для вагона #{Wagon.dimension(train.type)}: "
    capacity = gets.chomp
    wagon_count = attach_wagon!(train, capacity)
    puts "Вагон прицеплен. Стало вагонов: #{train.wagons_count}."
  end

  # action #4
  def detach_wagon
    train = select_train
    detach_wagon!(train)
    puts "Вагон отцеплен. Стало вагонов: #{train.wagons_count}."
  end

  # action #5
  def go_to_station
    train = select_train
    station = select_station
    relocation = train.teleport!(station)
    puts "Поезд отправился со станции «#{relocation[:from]}»." if !relocation[:from].nil?
    puts "Поезд прибыл на станцию «#{relocation[:to]}»."
  end

  # action #6
  def list_stations
    if Station.instances.zero?
      puts "В системе нет ни одной станции!"
    else
      puts "Станции в системе (#{Station.instances} шт.):"
      puts Station.all.keys
    end
  end

  # action #7
  def list_trains_on_station
    station = select_station
    show_trains(station)
  end

  # action #8
  def list_wagons
    train = select_train
    show_wagons(train)
  end

  # action #9
  def load_wagon
    train = select_train
    wagon = select_wagon(train)
    load_wagon!(wagon)
  end

  def select_train
    raise "Сначала создайте хотя бы один поезд!" if Train.list.empty?
    print "Введите номер поезда [#{Train.list.keys.join(', ')}]: "
    number = gets.chomp
    selected_train = Train.find(number)
    raise "Поезда с таким номером нет!" if selected_train.nil?
    selected_train
  end

  def select_station
    raise "В системе нет ни одной станции!" if Station.all.empty?
    print "Введите название станции [#{Station.all.keys.join(', ')}]: "
    name = gets.chomp
    selected_station = Station.find(name)
    raise "Станция с таким названием не найдена!" if selected_station.nil?
    selected_station
  end

  def select_wagon(train)
    show_wagons(train)
    print "Введите порядковый номер вагона: "
    i = gets.chomp.to_i
    wagon = train.wagons.fetch(i - 1) {raise "Вагон не найден!"}
  end

  def create_train!(type, number)
    raise "Некорректный тип поезда!" if ![1, 2].include?(type)
    train = type == 1 ? CargoTrain.new(number) : PassengerTrain.new(number)
    puts "#{train.number} создан."
    train
  end

  def create_station!(name)
    station = Station.new(name)
    puts "Станция «#{station}» создана."
  end

  def attach_wagon!(train, capacity)
    wagon = train.type == :cargo ? CargoWagon.new(capacity) : PassengerWagon.new(capacity)
    train.attach_wagon(wagon)
  end

  def detach_wagon!(train)
    train.detach_wagon
  end

  def load_wagon!(wagon)
    if wagon.type == :cargo
      print "Введите объём груза: "
      value = gets.chomp.to_f
      wagon.load(value)
    else
      wagon.take_a_seat
    end
    puts "Загрузка завершена."
  end

  def show_trains(station, with_wagons = false)
    if station.trains.empty?
      puts "На станции «#{station}» поездов нет."
    else
      puts "На станции «#{station}» находятся поезда:"
      station.each_train do |train|
        puts train
        show_wagons(train) if with_wagons
      end
    end
  end

  def show_wagons(train)
    putter = lambda { |wagon, i| puts "#{i + 1}. #{wagon}" }
    train.each_wagon_with_index(putter)
  end

  def display_all_objects
    Station.all.each_value do |station|
      puts BORDER
      show_trains(station, true)
    end
  end
end
