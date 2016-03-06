# coding: utf-8

require "fibonacci_rng/version"

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  #A class instance variable to hold the tickle value.
  @tickle = '0'

  #Create the default seed string.
  def self.new_seed
    Time.now.to_s + @tickle.succ!
  end

  #Get a random number from the class based generator. This exists only
  #for compatibility purposes. It is far better to create instances of
  #generators than to use a shared, global one.
  def self.rand(max=0)
    (@hidden ||= FibonacciRng.new).rand(max)
  end

  #Initialize the class based generator. This exists only
  #for compatibility purposes. It is far better to create instances of
  #generators than to use a shared, global one.
  def self.srand(seed=FibonacciRng.new_seed, depth=8)
    old = (@hidden && @hidden.seed)
    @hidden = FibonacciRng.new(seed, depth)
    old
  end

  CHOP = 0x1FFFFFFF
  BYTE = 0xFF
  WORD = 0xFFFF
  BASE = (CHOP+1).to_f

  #An accessor for the depth!
  attr_reader :depth

  #An accessor for the seed value!
  attr_reader :seed

  #Initialize the PRN generator
  def initialize(seed=FibonacciRng.new_seed, depth=8)
    fail "Invalid depth value (3..30)." unless (3..30) === depth
    @depth = depth
    srand(seed)
  end

  #Set up a new seed value
  def srand(seed=FibonacciRng.new_seed)
    @seed = seed
    @buffer = Array.new(@depth+2, 0)
    seedsrc = (seed.to_s + seed.class.to_s + 'Leonardo Pisano').each_byte.cycle
    indxsrc = (0...depth).cycle
    do_reseed(indxsrc, seedsrc)
  end

  #A (mostly) compatible access point for random numbers.
  def rand(max=0)
    @hidden ||= FibonacciRng.new

    if max.is_a?(Range)
      min = max.min
      @hidden.dice(1 + max.max - min) + min
    elsif max.zero?
      @hidden.float
    else
      @hidden.dice(max.to_i)
    end
  end

  #Roll a dice.
  def dice(sides)
    limit = ((CHOP+1) / sides) * sides

    begin
      do_spin
    end until (value = @buffer[0]) < limit

    value % sides
  end

  #Get a pseudo random byte
  def byte
    do_spin
    @buffer[0] & BYTE
  end

  #Get a string of random bytes
  def bytes(length)
    result = ""
    length.times {result << byte.chr}
    result
  end

  #Get a pseudo random word
  def word
    do_spin
    @buffer[0] & WORD
  end

  #Get a pseudo random float
  def float
    do_spin
    @buffer[0].to_f / BASE
  end

  #Cycle through the PRNG count times.
  def spin(count=1)
    count.times do
      do_spin
    end
  end

  private
  #Do the work of reseeding the PRNG
  def do_reseed(indxsrc, seedsrc)
    1024.times do
      @buffer[indxsrc.next] += seedsrc.next
      do_spin
    end
  end

  #Cycle through the PRNG once.
  def do_spin
    @buffer[-2] = @buffer[0]
    @buffer[-1] = @buffer[1]

    (0...@depth).each do |idx|
      @buffer[idx] = (@buffer[idx+1] + (@buffer[idx+2] >> 1)) & CHOP
    end
  end

end
