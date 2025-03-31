require_relative '../transport'

class Train < Transport
  IDENTIFIER = 'Train' # Para no tener que usar la constante de la clase Ruby, ya que restringiría en un futuro los nombres con espacios y le da info a un posible 3rd party/usuario
  REGEX = /^SEGMENT:\s+(?<type>\w+)\s+(?<source_location>\w+)\s+(?<start_time>\d{4}-\d{2}-\d{2}\s\d{2}:\d{2})\s+->\s+(?<destination_location>\w+)\s+(?<end_time>\d{2}:\d{2})$/

  include ParseableInterface

  # Añadir más codigo para customizar el comportamiento del tren, por ejemplo: diferente tipo de output, un mapeo distinto de los atributos, etc.
end
