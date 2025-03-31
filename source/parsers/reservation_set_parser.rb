require_relative 'reservation_parser'

class ReservationSetParser
  def self.parse(input)
    reservations = input.scan(/^RESERVATION.*?(?=RESERVATION|\z)/m)
    raise ParsingError.new("No reservations found in input: #{input.inspect}") if reservations.empty?

    reservations.map do |reservation_data|
      ReservationParser.parse(reservation_data)
    end
  end
end
