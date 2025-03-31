# require 'debug'
require 'time'
Dir[File.join(__dir__, 'source/**/*.rb')].sort.each { |file| require_relative file }

class Main
  def self.run
    input_file = ARGV[0]
    base_location = ENV['BASED'] # Obtiene la ubicación base desde la variable de entorno

    # Verifica que la variable de entorno BASED esté definida
    if base_location.nil? || base_location.strip.empty?
      puts "Error: La variable de entorno 'BASED' no está definida."
      exit(1)
    end

    # Leer el archivo de entrada
    unless File.exist?(input_file)
      puts "Error: El archivo '#{input_file}' no existe."
      exit(1)
    end

    input = File.read(input_file)
    begin
      segments = ReservationSetParser.parse(input) if Parser.valid_lines?(input)
    rescue ParsingError => e
      puts "Error: #{e.message}"
      return
    end
    sws = SegmentWrapper.wrap_all(segments)
    ts = TripSet.new(base_location: base_location, segments: sws)
    ts.find_trips!
    puts ts.output
  end
end

Main.run if __FILE__ == $0
