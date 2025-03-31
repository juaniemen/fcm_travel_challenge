class Segment
  attr_accessor :start_time, :end_time

  @@segments = []

  def initialize(start_time:, end_time:)
    raise ArgumentError, 'end_time must be later than start_time' if end_time < start_time

    @start_time = start_time
    @end_time = end_time
  end

  def self.all_segments
    @@segments
  end

  def self.clear_segments
    @@segments.clear
  end

  def self.assign_segments(segments)
    @@segments = segments
  end
end
