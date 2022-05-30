class ResourceContainer
  RESOURCE = 'resource'.freeze
  UNIT = 'unit'.freeze
  UNIT_PLURAL = 'units'.freeze
  UNIT_CONTRACTION = nil
  @min_value = 0
  @max_value = 100
  @is_frozen = false

  attr_reader :stored, :is_frozen

  @stored = 0

  def add(amount)
    throw TypeError, 'Method requires integer input' unless amount.instance_of?(Integer)
    throw RangeError, 'Value must be non-negative' unless amount >= 0
    unless amount + @stored <= @max_value
      throw RangeError, "#{self.class} cannot contain #{@stored} #{contracted_unit_name} of #{self.RESOURCE}"
    end

    add!(amount)
  end

  def add!(amount)
    @stored += amount
  end

  def remove(amount)
    throw TypeError, 'Method requires integer input' unless amount.instance_of?(Integer)
    throw RangeError, 'Value must be non-negative' unless amount >= 0
    unless amount - @stored >= @min_value
      throw RangeError, "#{self.class} does not have #{@stored} #{contracted_unit_name} of #{RESOURCE}"
    end

    remove!(amount)
  end

  def remove!(amount)
    throw RangeError, "Unable to remove #{amount} #{contracted_unit_name} of #{RESOURCE}" unless @stored >= amount
    @stored -= amount
  end

  def has?(amount)
    throw TypeError, 'Method requires integer input' unless amount.instance_of?(Integer)
    throw RangeError, 'Value must be non-negative' unless amount >= 0

    @stored >= amount
  end

  def unit_name
    @stored == 1 ? UNIT : UNIT_PLURAL
  end

  def contracted_unit_name
    UNIT_CONTRACTION.nil? ? unit_name : UNIT_CONTRACTION
  end

  def set_bounds(min, max)
    frozen_check
    throw TypeError, 'Bounds must be integer' unless min.instance_of?(Integer) && max.instance_of?(Integer)
    throw RangeError, 'Bounds must be non-negative' unless (min >= 0) && (max >= 0)

    @min_value = min
    @max_value = max
    return self
  end

  def freeze_bounds
    @is_frozen = true
    return self
  end

  def empty?
    @stored < @min_value || @stored.zero?
  end

  def within_bounds?
    # (@min_value...@max_value).include?(@stored)
    @min_value <= @stored && @stored <= @max_value
  end

  def safe?
    within_bounds?
  end

  protected

  def frozen_check
    throw RuntimeError, 'Container bounds have been frozen' if @is_frozen
  end
end
