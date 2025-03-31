class Trip
  attr_accessor :segments, :source_location, :destination_locations

  # Se tiene en cuenta de que las destination locations pueden ser varias, serán destinos
  # donde el usuario pase una al menos una noche de hotel o si no hay hotel, la última ciudad que visita

  HORAS_LINK_DE_TRANSPORTE = 24
  HORAS_MAXIMAS_DE_TRANSFER = 12
  # Si pasan más de 12 horas entre el final de un transporte y la llegada al hotel, se rompe la trip
  # Si pasan más de 12 horas entre el final de un hotel y la salida del transporte, se rompe la trip
  # Esto se hace porque es posible que un transporte llegue al hotel cercano a la madrugada y se llegue al alojamiento al día siguiente

  def initialize(source_location: nil)
    @segments = []
    @source_location = source_location
    @destination_locations = []
  end

  def add_segment(segment)
    @segments << segment
    return unless segment.segment.is_a?(Accommodation)

    @destination_locations << segment.destination_location
  end

  # Dado un segmento de inicio y unos segmentos candidatos, busca la trip
  # Realmente queue nunca contendrá más de un elemento, pero sería util en caso de que haya solapamiento
  # más de un hotel los mismo días por ejemplo, en tal caso se podría hacer busqueda en anchura/profundidad
  def self.find_trip(start_segment, segments)
    # Vamos a partir que la trip comienza en un transporte, un alojamiento en la ciudad BASED no está incluido en los candidatos y no estará incluida en la trip
    # Aquí reducimos los candidatos a los segmentos cuyo inicio no son la ciudad BASE.
    candidates = segments.reject do |sw|
      sw.source_location == start_segment.source_location && !sw.is_a?(Accommodation)
    end
    candidates.sort! { |a, b| segment_comparator(a.segment, b.segment) }
    queue = [start_segment]
    trip = Trip.new(source_location: start_segment.source_location)
    trip.add_segment(start_segment)

    until candidates.empty?
      current_segment = queue.shift
      candidate_segment = candidates.shift
      if current_segment.destination_location == candidate_segment.source_location &&
         check_times(current_segment, candidate_segment)
        trip.add_segment(candidate_segment)
        queue.push(candidate_segment)
        break if current_segment.destination_location == start_segment.source_location
      else
        queue.push(current_segment)
      end
    end

    trip.fill_empty_trip_destination!
    trip
  end

  def fill_empty_trip_destination!
    # Si no hay hoteles, la última ciudad que visita distinta de la base es el destino
    return unless destination_locations.empty?

    segments.reverse_each do |sw|
      if sw.destination_location != source_location
        destination_locations << sw.destination_location
        return
      end
    end
  end

  # Comprueba si el segmento candidato es válido para la trip, tiene en cuenta
  def self.check_times(current_segment, candidate_segment)
    if current_segment.segment.is_a?(Accommodation) && candidate_segment.segment.is_a?(Accommodation)
      # Se figura que el dia que sales de un hotel entras en otro, o al día siguiente,
      # si no se rompe la trip
      (current_segment.end_time.to_date == candidate_segment.start_time.to_date) ||
        ((current_segment.end_time.to_date + 1) == candidate_segment.start_time.to_date)
    elsif current_segment.segment.is_a?(Accommodation) && candidate_segment.segment.is_a?(Transport)
      # HORAS_MAXIMAS_DE_TRANSFER horas entre la salida del hotel y el inicio del transporte
      candidate_segment.start_time.to_date.between?(current_segment.end_time.to_date,
                                                    (current_segment.end_time + (HORAS_MAXIMAS_DE_TRANSFER * 60 * 60)).to_date)
    elsif current_segment.segment.is_a?(Transport) && candidate_segment.segment.is_a?(Accommodation)
      # HORAS_MAXIMAS_DE_TRANSFER horas entre el final de un transporte y el inicio de la llegada al hotel
      candidate_segment.start_time.to_date.between?(current_segment.end_time.to_date,
                                                    (current_segment.end_time + (HORAS_MAXIMAS_DE_TRANSFER * 60 * 60)).to_date)
    elsif current_segment.segment.is_a?(Transport) && candidate_segment.segment.is_a?(Transport)
      # Por definición de la prueba, 24 horas entre el final de un transporte y el inicio del siguiente
      candidate_segment.start_time.between?(current_segment.end_time,
                                            current_segment.end_time + HORAS_LINK_DE_TRANSPORTE * 60 * 60)
    else
      'NEVER WILL OCURR'
    end
  end

  # Para que el algoritmo de búsqueda funcione es muy importante el sorting, se ordenan por fecha de salida
  # IMPORTANTE: El alojamiento se asume que siempre tendrá al menos un día de duración.
  # Esto se hace para asegurar que el día que se llega a un alojamiento siempre va a ser menor que el día en el que se
  # sale del alojamiento
  def self.segment_comparator(a, b)
    if a.is_a?(Accommodation) && b.is_a?(Accommodation)
      a.end_time.to_date <=> b.end_time.to_date
    elsif a.is_a?(Transport) && b.is_a?(Transport)
      a.end_time <=> b.end_time
    elsif a.is_a?(Transport) && b.is_a?(Accommodation)
      result = a.end_time.to_date <=> b.end_time.to_date
      result.zero? ? 1 : result # Comparo por fechas y el caso de que sean iguales, el hotel va antes del viaje
    elsif a.is_a?(Accommodation) && b.is_a?(Transport)
      result = a.end_time.to_date <=> b.end_time.to_date
      result.zero? ? -1 : result # Comparo por fechas y el caso de que sean iguales, el hotel va antes del viaje
    else
      0
    end
  end

  def output
    "TRIP to #{destination_locations.join(', ')}"
  end
end
