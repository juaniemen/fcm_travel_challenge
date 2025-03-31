class TripSet
  attr_accessor :segments, :base_location
  attr_reader :trips

  def initialize(base_location:, segments:)
    @segments = segments
    @base_location = base_location
    @trips = []
  end

  # Una trip siempre comienza con un transporte desde la ciudad origen / Nunca con un hotel
  def find_trips!
    bases = segments.select do |m|
      m.segment.is_a?(Transport) && m.source_location == base_location
    end.sort_by { |m| m.start_time }

    candidate_segments = segments
    bases.map do |base_segment|
      trip = Trip.find_trip(base_segment, candidate_segments)
      candidate_segments -= trip.segments # Reducimos el pool de segmentos para mejorar eficiencia
      # Un segmento no puede pertenecer a más de una trip
      trips << trip
    end
  end

  def output
    trips.map do |trip|
      "#{trip.output}\n" +
        trip.segments.map do |sw|
          sw.segment.output
        end.join("\n")
    end.join("\n\n")
  end
end
