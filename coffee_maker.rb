require_relative 'classes/resource_containers/water_container'
require_relative 'classes/resource_containers/coffee_bean_container'
require_relative 'classes/resource_containers/milk_container'
require_relative 'classes/resources/coffee_cup_resource'
require_relative 'classes/coffee_recipe'

class CoffeeMaker
  # Possible states:
  # :under_construction - Maker is under construction in CoffeeMakerFactory
  # :off - Maker is turned off
  # :standby - Maker is turned on, awaiting instructions
  # :busy - Maker is busy making coffee
  # :done - Maker contains competed cup of coffee that was not retrieved
  # :out_of_resources - Maker is out of resources
  # :unsafe_resources - Maker contains unsafe resources
  # :broken - Maker got broken after use
  @state = :under_construction

  @water_container = nil
  @coffee_bean_container = nil
  @milk_container = nil
  @cup_container = nil

  @recipe_book = []
  @selected_recipe = nil
  @coffee_cup = nil
  @time_elapsed = 0

  def _create
    CoffeeMaker.new
  end

  def _set_water_container(container)
    under_construction_check(has_to_be: false)
    type_check(container, WaterContainer)
    container_frozen_check(container)

    _set_water_container!(container)
  end

  def _set_coffee_bean_container(container)
    under_construction_check(has_to_be: false)
    type_check(container, CoffeeBeanContainer)
    container_frozen_check(container)

    _set_coffee_bean_container!(container)
  end

  def _set_milk_container(container)
    under_construction_check(has_to_be: false)
    type_check(container, MilkContainer)
    container_frozen_check(container)

    _set_milk_container!(container)
  end

  def _set_cup_container(container)
    under_construction_check(has_to_be: false)
    type_check(container, CupContainer)
    container_frozen_check(container)

    _set_cup_container!(container)
  end

  def _add_recipe(recipe)
    under_construction_check
    type_check(recipe, CoffeeRecipe)
    throw ArgumentError, 'Recipe already included' if @recipe_book.include?(recipe)

    @recipe_book << recipe
  end

  def _finish_construction
    under_construction_check
    throw RangeError, 'No water container' if @water_container.nil?
    throw RangeError, 'No coffee bean container' if @coffee_bean_container.nil?
    throw RangeError, 'No milk container' if @milk_container.nil?
    throw RangeError, 'No cup container' if @cup_container.nil?
    throw RangeError, 'Recipe book must not be empty' if @recipe_book.length.zero?

    @state = :off
  end

  def turn_on
    under_construction_check
    throw RuntimeError, "#{self.class} is already turned on" unless @state == :off

    @state = :standby
  end

  def turn_off
    under_construction_check
    throw RuntimeError, "#{self.class} cannot be turned off" unless @state == :standby

    @state = :off
  end

  def load_coffee_beans(amount)
    @coffee_bean_container.add(amount)
  end

  def load_water(amount)
    @water_container.add(amount)
  end

  def load_milk(amount)
    @milk_container.add(amount)
  end

  def remove_coffee_beans
    @coffee_bean_container.remove(@coffee_bean_container.stored)
  end

  def remove_water
    @water_container.remove(@water_container.stored)
  end

  def remove_milk
    @milk_container.remove(@milk_container.stored)
  end

  def select_recipe(recipe)
    if recipe.instance_of?(Integer)
      throw RangeError, 'Index out of bounds' unless (-@recipe_book.length..@recipe_book.length).include?(recipe)

      @selected_recipe = @recipe_book[recipe]
    elsif recipe.instance_of?(CoffeeRecipe)
      throw ArgumentError, 'Recipe not in recipe book' unless @recipe_book.include?(recipe)

      @selected_recipe = recipe
    else throw TypeError, 'Argument must be either of type Integer or CoffeeRecipe' end
  end

  def start
    @coffee_bean_container.grind if !@coffee_bean_container.ground? && @coffee_bean_container.autogrind?
    unless safe?
      @state = :unsafe_resources
      puts 'Coffee maker is unsafe to run!'
      return
    end
    unless [
             @water_container.has(@selected_recipe.water),
             @coffee_bean_container.has(@selected_recipe.coffee_beans),
             @milk_container.has(@selected_recipe.milk),
             @cup_container.has(@selected_recipe.cup),
           ].all?(true)
      @state = :out_of_resources
      puts 'Coffee maker run out of resources!'
    end

    start!
  end

  def force_start
    # Check whether or not the user wants to shoot themselves in the foot
    # Intentionally left away autogrind functionality
    if @state != :standby
      throw RuntimeError, "Invalid state: #{@state}"
    elsif @selected_recipe.nil? || !@recipe_book.includes?(@selected_recipe)
      @state = :broken
      throw RuntimeError, 'Invalid recipe'
    elsif !safe?
      @state = :broken
      throw RuntimeError, 'It was unsafe to start the coffee maker'
    elsif !@water_container.has?(@selected_recipe.water)
      @state = :broken
      throw RuntimeError, 'Not enough water'
    elsif !@coffee_bean_container.has?(@selected_recipe.coffee_beans)
      @state = :broken
      throw RuntimeError, 'Not enough coffee beans'
    elsif !@milk_container.has?(@selected_recipe.milk)
      @state = :broken
      throw RuntimeError, 'Not enough milk'
    elsif !@cup_container.has?(@selected_recipe.cup)
      @state = :broken
      throw RuntimeError, 'Invalid cup'
    end

    start!
  end

  def start!
    @water_container.remove!(@selected_recipe.water)
    @coffee_bean_container.remove!(@selected_recipe.coffee_beans)
    @milk_container.remove!(@selected_recipe.milk)
    @cup_container.remove!(@selected_recipe.cup)

    @state = :busy
    @time_elapsed = 0
    finish if @selected_recipe.time.zero?
  end

  private

  def finish
    @state = :done
    @coffee_cup = CoffeeCup.new(@selected_recipe.name)
  end

  def safe?
    [
      @water_container,
      @coffee_bean_container,
      @milk_container,
      @cup_container,
    ].all? & :safe?
  end

  def _set_water_container!(container)
    @water_container = container
  end

  def _set_coffee_bean_container!(container)
    @coffee_bean_container = container
  end

  def _set_milk_container!(container)
    @milk_container = container
  end

  def _set_cup_container!(container)
    @cup_container = container
  end

  def under_construction_check(has_to_be: true)
    throw RuntimeError, "#{self.class} is#{has_to_be ? ' not' : ''} under construction" unless (@state == :under_construction) == has_to_be
  end

  def type_check(arg, type)
    throw TypeError, "Argument must be of type #{type}" unless arg.instance_of?(type)
  end

  def container_frozen_check(container)
    throw ArgumentError, 'Container must be frozen' unless container.is_frozen
  end

  def initialize
  end
end
