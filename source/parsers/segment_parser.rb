require_relative '../models/segment'
require_relative '../common/parseable_interface'

class SegmentParser
  def self.parse(input)
    regexp = /^SEGMENT:\s+(?<type>\w+)/
    match = input.match(regexp)
    raise ParsingError.new("Error parsing segment type at input: #{input.inspect}") unless match

    klass = ParseableInterface.classes[match[:type]]
    raise ParsingError.new("Unknown segment type '#{match[:type]}' at input: #{input.inspect}") unless klass

    params = input.match(klass::REGEX)
    raise ParsingError.new("Error parsing segment parameters at input: #{input.inspect}") unless params

    # Capturar excepciones de argumentos, ej: poner una hora inválida, y otros
    begin
      klass.new(**klass.attributes(params.named_captures.transform_keys(&:to_sym)))
    rescue ArgumentError => e
      raise ParsingError.new("Error instantiating segment: #{e.message} at input: #{input.inspect}")
    end
  end
end
