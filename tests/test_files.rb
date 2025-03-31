require 'minitest/autorun'
require_relative '../main'

class TestFiles < Minitest::Test
  FILES_DIR = File.expand_path('files', __dir__)
  BASE_LOCATION = 'SVQ'

  # Probar que los errores que las fechas se manejan correctamente y arrojan error cuando son invalidas
  def test_input_argunt_error_dates_1
    # En este fichero hay una fecha con hora incorrecta (25:00)
    input_file = 'input_argument_error_dates_1.txt'
    input = File.read(file_path(input_file))
    assert_raises(ParsingError) do
      ReservationSetParser.parse(input) if Parser.valid_lines?(input)
    end
  end

  # Probar que los errores que las fechas se manejan correctamente y arrojan error cuando son invalidas
  def test_input_argunt_error_dates_2
    # En este fichero hay una fecha de salida inferior a una fecha de entrada
    input_file = 'input_argument_error_dates.txt'
    input = File.read(file_path(input_file))
    assert_raises(ParsingError) do
      ReservationSetParser.parse(input) if Parser.valid_lines?(input)
    end
  end

  # Probar que el location destino no puede ser igual a la location salida
  def test_input_argunt_error_destination
    input_file = 'input_argument_error_destination.txt'
    input = File.read(file_path(input_file))
    assert_raises(ParsingError) do
      ReservationSetParser.parse(input) if Parser.valid_lines?(input)
    end
  end

  # Probar el caso en el que sale bien, hay trips con multiples destinos también
  def test_input_argunt_error_destination
    input_file = 'input_large.txt'
    input = File.read(file_path(input_file))
    segments = ReservationSetParser.parse(input) if Parser.valid_lines?(input)
    sws = SegmentWrapper.wrap_all(segments)
    ts = TripSet.new(base_location: BASE_LOCATION, segments: sws)
    ts.find_trips!
    assert_equal 5, ts.trips.size
    assert_equal %w[BCN MAD NYC LAX LIS], ts.trips.map(&:destination_locations).flatten.uniq

    output_file = file_path('output/input_large.txt')
    output = File.read(output_file)
    assert_equal output, ts.output
  end

  private

  def file_path(input_file)
    File.join(FILES_DIR, input_file)
  end
end
