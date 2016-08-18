class Controller
  BORDER = "---" * 5;
  attr_reader :stations, :trains

  def initialize
    @stations = []
    @trains = []
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
    when "6"
      list_stations
    else
      puts "Неизвестная команда!"
    end

    puts BORDER;
  end

  private

  # action #1
  def create_station
    loop do
      print "Укажите название станции: "
      name = gets.chomp

      check = validate_station(name)
      if check[:success]
        create_station!(name)
        break
      else
        puts check[:errors]
      end
    end
  end

  # action #2
  def create_train
    loop do
      print "Введите номер поезда: "
      number = gets.chomp
      print "Укажите тип поезда ([1] > грузовой, [2] > пассажирский): "
      type = gets.chomp.to_i
      
      check = validate_train(type, number)
      if check[:success]
        create_train!(type, number)
        break
      else
        puts check[:errors]
      end
    end
  end

  # action #3
  def attach_wagon
    # предложить пользователю выбрать поезд, введя название
    # если поезд найден, опередлить его тип
    # создать инстанс вагона того же типа
    # прицепить
    # показать обновленную инфу о поезде
  end
  
  # action #6
  def list_stations
    puts "Станции в системе:"
    puts self.stations
  end

  def validate_train(type, number)
    errors = []
    valid_types = [1, 2]
    errors << "Номер поезда не может быть пуст!" if number.empty?
    errors << "Некорректный тип поезда!" if !valid_types.include?(type)
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end

  def validate_station(name)
    errors = []
    errors << "Название станции обязательно!" if name.empty?
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end

  def create_train!(type, number)
    train = type == 1 ? CargoTrain.new(number) : PassengerTrain.new(number)
    @trains << train
    puts "#{train} создан."
    puts train.info
  end

  def create_station!(name)
    station = Station.new(name)
    @stations << station
    puts "Станция «#{station}» создана."
  end
  
end
