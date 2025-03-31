require_relative '../accommodation'

class Hotel < Accommodation
  IDENTIFIER = 'Hotel'
  REGEX = /^SEGMENT:\s+Hotel\s+(?<location>\w+)\s+(?<start_time>\d{4}-\d{2}-\d{2})\s+->\s+(?<end_time>\d{4}-\d{2}-\d{2})$/

  include ParseableInterface
end
