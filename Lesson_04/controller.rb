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
    input = ["Укажите название станции: "]
    iterate(input, :validate_station, :create_station!)
  end

  # action #2
  def create_train
    input = ["Укажите тип поезда ([1] > грузовой, [2] > пассажирский): ",
    "Введите номер поезда: "]
    iterate(input, :validate_train, :create_train!)
  end

  # action #3
  def attach_wagon
    if self.trains.empty?
      puts "Сначала создайте хотя бы один поезд."
    else
      input = ["Введите номер поезда [#{self.trains.keys.join(', ')}]: "]
      iterate(input, :validate_train_selection, :attach_wagon!)
    end
  end

  # action #4
  def detach_wagon
    if self.trains.empty?
      puts "Сначала создайте хотя бы один поезд."
    else
      input = ["Введите номер поезда [#{self.trains.keys.join(', ')}]: "]
      iterate(input, :validate_train_selection, :detach_wagon!)
    end
  end

  # action #5
  def go_to_station

  end

  # action #6
  def list_stations
    puts "Станции в системе:"
    puts self.stations
  end

  # action #7
  def list_trains_on_station
    
  end

  def iterate(input, validator, success_callback)
    loop do
      args = []
      input.each do |message|
        print "#{message}"
        args << gets.chomp
      end
      
      check = self.send(validator, *args)
      if check[:success]
        self.send(success_callback, *args)
        break
      else
        puts check[:errors]
      end
    end
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
      {success: false, 'errors': "Поезда с таким номером нет"}
    end
  end

  def create_train!(type, number)
    train = type == 1 ? CargoTrain.new(number) : PassengerTrain.new(number)
    @trains[number.to_sym] = train
    puts "#{train} создан."
    puts "#{train.info}."
  end

  def create_station!(name)
    station = Station.new(name)
    @stations[name.to_sym] = station
    puts "Станция «#{station}» создана."
  end

  def attach_wagon!(number)
    selected_train = self.trains[number.to_sym]
    type = selected_train.type
    wagon = type == :cargo ? CargoWagon.new() : PassengerWagon.new()
    selected_train.attach_wagon(wagon)
  end

  def detach_wagon!(number)
    selected_train = self.trains[number.to_sym]
    last_wagon = selected_train.wagons.last
    selected_train.detach_wagon(last_wagon)
  end
  
end
