require_relative '../segment'

# Clase abstracta, no define IDENTIFIER ni REGEX
class Transport < Segment
  attr_accessor :source_location, :destination_location

  def initialize(source_location:, destination_location:, start_time:, end_time:)
    raise ArgumentError, 'Destination and location cannot be equals' if source_location == destination_location

    super(start_time: start_time, end_time: end_time)
    @source_location = source_location
    @destination_location = destination_location
  end

  def self.attributes(hash)
    start_time_object = Time.parse(hash[:start_time])
    end_hours, end_minutes = hash[:end_time].split(':').map(&:to_i)

    {
      source_location: hash[:source_location],
      destination_location: hash[:destination_location],
      start_time: start_time_object,
      end_time: Time.new(start_time_object.year, start_time_object.month, start_time_object.day, end_hours, end_minutes)
    }
  end

  def output
    "#{self.class::IDENTIFIER} from #{source_location} to #{destination_location} at #{start_time.strftime('%Y-%m-%d %H:%M')} to #{end_time.strftime('%H:%M')}"
  end
end
