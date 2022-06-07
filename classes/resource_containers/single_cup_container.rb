require_relative 'base_cup_container'

class SingleCupContainer < BaseCupContainer
  @cup = nil
  @is_frozen = true

  def add(cup)
    BaseCupContainer.check_cup_validity(cup)
    raise "#{@cup.to_s.capitalize} cup already loaded" unless @cup.nil?

    add!(cup)
  end

  def add!(cup)
    @cup = cup
  end

  def remove(_cup = nil)
    raise 'No cup to remove' if @cup.nil?

    remove!
  end

  def remove!(_cup = nil)
    @cup = nil
  end

  def empty
    remove!
  end

  def empty?
    @cup.nil?
  end

  def has?(cup)
    super
    @cup == cup
  end
end
