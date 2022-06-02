require_relative '../validator'

# Marks a resource as one able to expire.
#
# When a CoffeeMaker is used, it takes some time, which makes the resource spoil.
# After time_elapsed reaches or exceeds TIME_BEFORE_EXPIRY, the resource is no longer safe to use.
# Using expired resource might clog up the pipes, which will force the resource to break.
#
# Intended for BaseResourceContainer classes.
module Expireable
  TIME_BEFORE_EXPIRY = 0

  @time_elapsed = 0

  def expired?
    self.class::TIME_BEFORE_EXPIRY.zero? ? false : @time_elapsed >= self.class::TIME_BEFORE_EXPIRY
  end

  def wait(time)
    Validator.integer?(time)
    Validator.non_negative?(time)

    @time_elapsed += time
  end
end
