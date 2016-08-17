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
    when "6"
      list_stations
    else
      puts "Неизвестная команда!"
    end

    puts BORDER;
  end

  private

  def create_station
    print "Укажите название станции: "
    station = Station.new(gets.chomp)
    @stations << station
    puts "Станция «#{station}» создана."
  end

  def create_train
    loop do
      print "Введите номер поезда: "
      number = gets.chomp
      print "Укажите тип поезда ([1] > грузовой, [2] > пассажирский): "
      type = gets.chomp.to_i
      if type == 1
        train = CargoTrain.new(number)
      elsif type == 2
        train = PassengerTrain.new(number)
      end
      break if !train.nil?
    end
  end

  def list_stations
    puts "Станции в системе:"
    puts self.stations
  end
  
end
