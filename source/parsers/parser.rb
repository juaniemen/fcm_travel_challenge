class Parser
  REGEX_CHECK = {
    segments: ParseableInterface.classes.values.map { |klass| klass::REGEX },
    reservation: [/^RESERVATION$/]
  }

  def self.valid_lines?(input)
    input.each_line.with_index(1) do |line, line_number|
      next if line.strip.empty? || line.strip.start_with?('#') # Ignorar líneas vacías o que comienzan con #

      # Verificar si la línea cumple con al menos una regex
      unless REGEX_CHECK.values.flatten.any? { |regex| line.match?(regex) }
        raise ParsingError.new("Parsing Error at #{line_number}: Invalid format. -> #{line.inspect}")
      end
    end
    true
  end
end

class ParsingError < StandardError; end
