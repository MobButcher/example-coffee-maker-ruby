require 'set'
require_relative 'classes/resource_containers/water_container'
require_relative 'classes/resource_containers/coffee_bean_container'
require_relative 'classes/resource_containers/milk_container'
require_relative 'classes/resources/water_resource'
require_relative 'classes/resources/coffee_bean_resource'
require_relative 'classes/resources/coffee_cup_resource'
require_relative 'classes/coffee_recipe'
require_relative 'classes/coffee'
require_relative 'classes/validator'

class CoffeeMaker
  TOKEN = '57f6d568241f187200cd6071b5f495fe1b2d7d8400562ef807777d40871b35ae'.freeze # SHA256("CoffeeMakerSecret")
  POSSIBLE_STATES = [
    :under_construction,  # Maker is under construction in CoffeeMakerFactory
    :off,                 # Maker is turned off
    :standby,             # Maker is turned on, awaiting instructions
    :busy,                # Maker is busy making coffee
    :done,                # Maker contains competed cup of coffee that was not retrieved
    :out_of_resources,    # Maker is out of resources
    :unsafe_resources,    # Maker contains unsafe resources
    :broken,              # Maker got broken after use
  ].freeze
  REQUIRED_RESOURCES = [
    WaterResource,
    CoffeeBeanResource,
    CoffeeCupResource,
  ].freeze

  attr_reader :selected_recipe, :coffee_cup, :time_elapsed

  # A subset of POSSIBLE_STATES
  @state = Set[:under_construction]

  @containers = []

  @recipe_book = []
  @selected_recipe = nil
  @coffee_cup = nil
  @time_elapsed = 0

  def initialize(token:)
    token_check(token)
  end

  def add_container(container, token:)
    token_check(token)
    under_construction_check(expected_to_be: false)
    Validator.of_type?(BaseResourceContainer, container)
    Validator.frozen?(container)
    unless @containers.none? { |installed| container.class::RESOURCE == installed.class::RESOURCE}
      raise TypeError, "A container for #{container.class::RESOURCE} has already been installed"
    end

    add_container!(container)
  end

  def add_recipe(recipe, token:)
    token_check(token)
    under_construction_check
    broken_check
    Validator.of_type?(CoffeeRecipe, recipe)
    raise ArgumentError, 'Recipe already included' if @recipe_book.include?(recipe)

    @recipe_book << recipe
  end

  def finish_construction(token:)
    token_check(token)
    under_construction_check
    unless self.class::REQUIRED_RESOURCES.all? { |resource| [].find { |container| container::RESOURCE == resource } }
      raise "#{self.class} is missing some of the containers for required resources"
    end
    raise RangeError, 'Recipe book must not be empty' if @recipe_book.length.zero?

    @state.delete(:under_construction)
    @state.add(:off)
  end

  def turn_on
    under_construction_check
    broken_check
    raise "#{self.class} is already turned on" unless @state.include?(:off)

    @state.delete(:off)
    @state.add(:standby)
  end

  def turn_off
    under_construction_check
    broken_check
    raise "#{self.class} cannot be turned off" unless @state.include?(:standby)

    @state.delete(:standby)
    @state.add(:off)
  end

  def load_coffee_beans(amount)
    find_container_of(CoffeeBeanResource).add(amount)
  end

  def load_water(amount)
    find_container_of(WaterResource).add(amount)
  end

  def load_milk(amount)
    find_container_of(MilkResource).add(amount)
  end

  def remove_coffee_beans
    find_container_of(CoffeeBeanResource).empty
  end

  def remove_water
    find_container_of(WaterResource).empty
  end

  def remove_milk
    find_container_of(MilkResource).empty
  end

  def load_coffee_cup(coffee_cup)
    find_container_of(CoffeeCupResource).add(coffee_cup)
  end

  def remove_coffee_cups!
    find_container_of(CoffeeCupResource).empty
  end

  def select_recipe(recipe)
    broken_check
    if recipe.instance_of?(Integer)
      raise RangeError, 'Index out of bounds' unless (-@recipe_book.length..@recipe_book.length).include?(recipe)

      @selected_recipe = @recipe_book[recipe]
    elsif recipe.instance_of?(CoffeeRecipe)
      raise ArgumentError, 'Recipe not in recipe book' unless @recipe_book.include?(recipe)

      @selected_recipe = recipe
    else
      raise TypeError, 'Argument must be either of type Integer or CoffeeRecipe'
    end
  end

  def start
    broken_check
    if @selected_recipe.nil?
      puts 'No recipe selected!'
      return
    end
    unless @selected_recipe.ingredients.all? { |resource, value| find_container_of(resource).has?(value) }
      @state.add(:out_of_resources)
      puts 'Not enough resources!'
      return
    end

    coffee_bean_container = find_container_of(CoffeeBeanResource)
    coffee_bean_container.grind if !coffee_bean_container.ground? && coffee_bean_container.autogrind?
    unless safe?
      @state.add(:unsafe_resources)
      puts 'Coffee maker is unsafe to run!'
      return
    end

    @state.delete(:out_of_resources)
    @state.delete(:unsafe_resources)

    start!
  end

  def force_start
    # Check whether or not the user wants to shoot themselves in the foot
    # Intentionally left away autogrind functionality
    if @state.intersect?([:under_construction, :done, :busy, :broken]) || !@state.include?(:standby)
      raise "Invalid state: #{@state}"
    end
    if @selected_recipe.nil? || !@recipe_book.include?(@selected_recipe)
      @state.add(:broken)
      raise 'Invalid recipe'
    end
    unless safe?
      @state.add(:broken)
      @state.add(:unsafe_resources)
      raise 'It was unsafe to start the coffee maker'
    end
    @selected_recipe.ingredients.each do |resource, value|
      next if find_container_of(resource).has?(value)

      @state.add(:broken)
      @state.add(:out_of_resources)
      raise "#{self.class} didn't have enough #{resource::NAME} to make #{@selected_recipe.name}"
    end

    start!
  end

  def wait(time)
    Validator.integer?(time)
    Validator.non_negative?(time)
    broken_check

    wait!(time)
  end

  def take_coffee
    raise 'Coffee is not done preparing' unless @state.include?(:done)
    raise 'There is no coffee to take' if @coffee_cup.nil?

    take_coffee!
  end

  private

  def finish
    finish! if @time_elapsed >= @selected_recipe.time
  end

  def finish!
    @state.delete(:busy)
    @state.add(:done)
    @coffee_cup = Coffee.new(@selected_recipe.name)
  end

  def take_coffee!
    result = @coffee_cup
    @coffee_cup = nil
    result
  end

  def wait!(time)
    @time_elapsed += time
    @containers.each { |container| container.wait(time) if container.instance_of?(Expireable) }
    finish
  end

  def find_container_of(resource)
    Validator.of_type?(BaseResource, resource)
    @containers.find { |container| container::RESOURCE == resource }
  end

  def safe?
    @containers.all? & :safe?
  end

  def add_container!(container)
    @containers << container
  end

  def start!
    @selected_recipe.ingredients.each { |resource, value| find_container_of(resource).remove!(value) }

    @state.add(:busy)
    @time_elapsed = 0
    finish! if @selected_recipe.time.zero?
  end

  def under_construction_check(expected_to_be: true)
    return if (@state.include?(:under_construction)) == expected_to_be

    raise "#{self.class} is#{expected_to_be ? ' not' : ''} under construction"
  end

  def type_check(arg, type)
    raise TypeError, "Argument must be of type #{type}" unless arg.instance_of?(type)
  end

  def container_frozen_check(container)
    raise ArgumentError, 'Container must be frozen' unless container.is_frozen
  end

  def token_check(token)
    raise SecurityError, 'Unauthorized initialization attempt' unless token == TOKEN
  end

  def broken_check
    raise "#{self.class} is broken" if @state.include?(:broken)
  end
end
