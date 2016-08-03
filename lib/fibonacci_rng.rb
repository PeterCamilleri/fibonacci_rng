# coding: utf-8

require_relative "fibonacci_rng/seeder"
require_relative "fibonacci_rng/hasher"
require_relative "fibonacci_rng/spinner"
require_relative "fibonacci_rng/generator"
require_relative "fibonacci_rng/version"

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  CHOP   = 0x1FFFFFFF
  TOP    = 0x10000000
  BYTE   = 0xFF
  WORD   = 0xFFFF
  BASE   = (CHOP+1).to_f
  DOUBLE = BASE*BASE
  DEPTHS = 2..256
  INITS  = 1..1_000_000

  #The depth of the Fibonacci array.
  attr_reader :depth

  #The seed value used by this generator.
  attr_reader :seed

  #The init value used by this generator.
  attr_reader :init

  #Initialize the PRN generator
  def initialize(arg_a=nil, arg_b=nil, arg_c=nil)
    #Extract the parameters.
    if arg_a.is_a?(Hash)
      seed   = arg_a[:seed]
      @depth = arg_a[:depth]
      @init  = arg_a[:init]
    else
      seed   = arg_a
      @depth = arg_b
      @init  = arg_c
    end

    #Set up the default parameters if needed.
    seed   ||= FibonacciRng.new_seed
    @depth ||= 8

    #Validate the depth.
    unless DEPTHS === @depth
      fail "Invalid depth value #{@depth}. Allowed values are #{DEPTHS}"
    end

    @init ||= 32 * @depth + 768

    #Validate the depth.
    unless INITS === @init
      fail "Invalid init value #{@init}. Allowed values are #{INITS}"
    end

    #Build the generator.
    srand(seed)
  end

  #Get a random number from the class based generator. This exists only
  #for compatibility purposes. It is far better to create instances of
  #generators than to use a shared, global one.
  #<br>Returns
  #* The computed pseudo-random value.
  def self.rand(max=0)
    (@hidden ||= FibonacciRng.new).rand(max)
  end

  #Initialize the class based generator. This exists only
  #for compatibility purposes. It is far better to create instances of
  #generators than to use a shared, global one.
  #<br>Returns
  #* The old seed value.
  def self.srand(seed=FibonacciRng.new_seed, depth=8)
    old = (@hidden && @hidden.seed)
    @hidden = FibonacciRng.new(seed, depth)
    old
  end

end
