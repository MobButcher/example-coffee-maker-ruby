class BaseResource
  NAME = 'resource'.freeze
  UNIT = 'unit'.freeze
  UNIT_PLURAL = 'units'.freeze
  UNIT_CONTRACTION = nil

  def self.unit_name
    @stored == 1 ? self.class::UNIT : self.class::UNIT_PLURAL
  end

  def self.contracted_unit_name
    self.class::UNIT_CONTRACTION.nil? ? unit_name : self.class::UNIT_CONTRACTION
  end
end
