module ParseableInterface
  @@CLASSES = {}

  def self.included(base)
    # Verifica que las constantes IDENTIFIER y REGEX estén definidas
    unless base.const_defined?(:IDENTIFIER) && base.const_defined?(:REGEX)
      raise "#{base} must define constants IDENTIFIER and REGEX"
    end

    # Verifica que el método de clase attributes esté definido
    unless base.singleton_class.method_defined?(:attributes)
      raise "#{base} must define a class method called attributes"
    end

    # Verifica que el método de instancia output esté definido
    raise "#{base} must define an instance method called output" unless base.method_defined?(:output)

    # Registra la clase en @@CLASSES usando su IDENTIFIER
    @@CLASSES[base::IDENTIFIER] = base
  end

  def self.classes
    @@CLASSES
  end
end
