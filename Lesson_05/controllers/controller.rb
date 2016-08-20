class Controller
  BORDER = "---" * 5;
  attr_reader :stations, :trains

  def initialize
    @stations = {}
    @trains = {}
  end

  def show_actions
    puts "Для выбора действия введите его порядковый номер: "
    puts "[1] > Создать станцию"
    puts "[2] > Создать поезд"
    puts "[3] > Добавить к поезду вагон"
    puts "[4] > Отцепить вагон от поезда"
    puts "[5] > Поместить поезд на станцию"
    puts "[6] > Посмотреть список станций"
    puts "[7] > Посмотреть список поездов на станции"
    puts BORDER;
    puts "Выход: exit"
    puts BORDER;
  end

  def run_action(action)
    case action
    when "1"
      create_station
    when "2"
      create_train
    when "3"
      attach_wagon
    when "4"
      detach_wagon
    when "5"
      go_to_station
    when "6"
      list_stations
    when "7"
      list_trains_on_station
    else
      puts "Неизвестная команда!"
    end

    puts BORDER;
  end

  private

  # action #1
  def create_station
    request = ["Укажите название станции: "]
    process_input(request, :validate_station, :create_station!)
  end

  # action #2
  def create_train
    request = ["Укажите тип поезда ([1] > грузовой, [2] > пассажирский): ",
    "Введите номер поезда: "]
    process_input(request, :validate_train, :create_train!)
  end

  # action #3
  def attach_wagon
    if self.trains.empty?
      puts "Сначала создайте хотя бы один поезд."
    else
      request = ["Введите номер поезда [#{self.trains.keys.join(', ')}]: "]
      process_input(request, :validate_train_selection, :attach_wagon!)
    end
  end

  # action #4
  def detach_wagon
    if self.trains.empty?
      puts "Сначала создайте хотя бы один поезд."
    else
      request = ["Введите номер поезда [#{self.trains.keys.join(', ')}]: "]
      process_input(request, :validate_train_selection, :detach_wagon!)
    end
  end

  # action #5
  def go_to_station
    if self.trains.empty? || self.stations.empty?
      puts "Должен быть хотя бы один поезд и одна станция."
    else
      request = ["Введите номер поезда [#{self.trains.keys.join(', ')}]: "]
      train = process_input(request, :validate_train_selection, :select_train)
      request = ["Введите название станции [#{self.stations.keys.join(', ')}]: "]
      station = process_input(request, :validate_station_selection, :select_station)
      train.teleport!(station)
    end
  end

  # action #6
  def list_stations
    if self.stations.empty?
      puts "В системе нет ни одной станции!"
    else
      puts "Станции в системе (#{Station.all}):"
      puts self.stations.keys
    end
  end

  # action #7
  def list_trains_on_station
    if self.stations.empty?
      puts "В системе нет ни одной станции!"
    else
      request = ["Введите название станции [#{self.stations.keys.join(', ')}]: "]
      station = process_input(request, :validate_station_selection, :select_station)
      station.show_trains
    end
  end

  # хотелось избежать дублирования кода, поэтому что-то такое изобрела
  # название не самое очевидное, но более удачного не придумалось
  def process_input(request, validator, success_callback)
    response = nil
    loop do
      args = []
      request.each do |message|
        print "#{message}"
        args << gets.chomp
      end
      
      check = self.send(validator, *args)
      if check[:success]
        response = self.send(success_callback, *args)
        break
      else
        puts check[:errors]
      end
    end
    response
  end

  def validate_train(type, number)
    errors = []
    valid_types = ["1", "2"]
    errors << "Номер поезда не может быть пуст!" if number.empty?
    errors << "Некорректный тип поезда!" if !valid_types.include?(type)
    errors << "Поезд с таким номером уже есть" if self.trains[number.to_sym]
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end

  def validate_station(name)
    errors = []
    errors << "Название станции обязательно!" if name.empty?
    errors << "Станция с таким именем уже есть" if self.stations[name.to_sym]
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end

  def validate_train_selection(number)
    if self.trains[number.to_sym]
      {success: true}
    else
      {success: false, 'errors': "Поезда с таким номером нет!"}
    end
  end

  def validate_station_selection(name)
    if self.stations[name.to_sym]
      {success: true}
    else
      {success: false, 'errors': "Такой станции нет!"}
    end
  end

  def select_train(number)
    selected_train = self.trains[number.to_sym]
  end

  def select_station(name)
    selected_station = self.stations[name.to_sym]
  end

  def create_train!(type, number)
    train = type == 1 ? CargoTrain.new(number) : PassengerTrain.new(number)
    @trains[number.to_sym] = train
    puts "#{train} создан."
    puts "#{train.info}"
  end

  def create_station!(name)
    station = Station.new(name)
    @stations[name.to_sym] = station
    puts "Станция «#{station}» создана."
  end

  def attach_wagon!(number)
    selected_train = select_train(number)
    type = selected_train.type
    wagon = type == :cargo ? CargoWagon.new() : PassengerWagon.new()
    selected_train.attach_wagon(wagon)
  end

  def detach_wagon!(number)
    selected_train = select_train(number)
    selected_train.detach_wagon
  end
  
end
