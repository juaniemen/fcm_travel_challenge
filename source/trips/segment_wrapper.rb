# Clase destinada a crear una interfaz común para los segmentos
class SegmentWrapper
  attr_accessor :source_location, :destination_location, :start_time, :end_time, :segment

  @@segments = []

  def initialize(segment)
    @segment = segment
    @source_location = segment.respond_to?(:source_location) ? segment&.source_location : segment.location
    @destination_location = segment.respond_to?(:destination_location) ? segment&.destination_location : segment.location
    @start_time = segment.start_time
    @end_time = segment.end_time
  end

  def self.wrap_all(segments)
    segments.flatten.map { |segment| SegmentWrapper.new(segment) }
  end
end
