class BaseCoffeeMakerFactory
  # A hash of {:modelSymbol = ModelClass} entries.
  MODELS = {}.freeze

  def build(model)
    raise "Model #{model} is not available" unless self.class::MODELS.include?(model)

    self.class::MODELS[model].new.build
  end
end
