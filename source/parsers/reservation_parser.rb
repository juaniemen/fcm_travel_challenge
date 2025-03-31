require_relative '../models/segment'
require_relative './segment_parser'
require_relative './parser'

class ReservationParser
  def self.parse(input)
    segments = input.scan(/^SEGMENT: .+/)
    raise ParsingError.new("No segments found in reservation input: #{input.inspect}") if segments.empty?

    segments.map { |segment| SegmentParser.parse(segment) }
  end
end
