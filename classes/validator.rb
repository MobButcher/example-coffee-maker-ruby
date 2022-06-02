# Static class for value validation
# raises on false validations
# Undefined result on true validations
class Validator
  def self.integer?(input, error: nil)
    Validator.of_type?(Integer, input, error: error)
  end

  def self.of_type?(type, input, error: nil)
    raise TypeError, error || "Value #{input} must be of type #{type}" unless input.instance_of?(type)
  end

  def self.non_negative?(input, error: nil)
    raise RangeError, error || "Value #{input} must be non-negative" unless input >= 0
  end

  def self.within?(min, max, input, error: nil)
    raise RangeError, error || "Value #{input} must be between #{min} and #{max}" unless min <= input && input <= max
  end

  def self.not_above?(max, input, error: nil)
    raise RangeError, error || "Value #{input} must not be above #{max}" unless input <= max
  end

  def self.not_below?(min, input, error: nil)
    raise RangeError, error || "Value #{input} must not be below #{min}" unless min <= input
  end

  def self.frozen?(input, error: nil)
    raise TypeError, "#{input.class} object does not have .frozen? property" unless input.respond_to?(:frozen?)
    raise SecurityError, error || "#{input.class} object has been frozen" if input.frozen?
  end
end
