require_relative '../segment'

class Accommodation < Segment
  attr_accessor :location

  def initialize(location:, start_time:, end_time:)
    raise ArgumentError, 'end_time must be at least one day after start_time' if (end_time - start_time) < 86_400

    super(start_time: start_time, end_time: end_time)
    @location = location
  end

  def self.attributes(hash)
    {
      location: hash[:location],
      start_time: Time.parse(hash[:start_time]),
      end_time: Time.parse(hash[:end_time])
    }
  end

  def output
    "#{self.class::IDENTIFIER} at #{location} on #{start_time.strftime('%Y-%m-%d')} to #{end_time.strftime('%Y-%m-%d')}"
  end
end
