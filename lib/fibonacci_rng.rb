# coding: utf-8

require "fibonacci_rng/version"

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  #A class instance variable to hold the tickle value.
  @tickle = '0'

  #Create the default seed string.
  def self.seed
    Time.now.to_s + @tickle.succ!
  end

  CHOP = 0x1FFFFFFF
  BYTE = 0xFF
  WORD = 0xFFFF
  BASE = (CHOP+1).to_f

  #An accessor for the depth!
  attr_reader :depth

  #Initialize the PRN generator
  def initialize(depth=8, seed=FibonacciRng.seed)
    fail "Invalid depth value (3..30)." unless (3..30) === depth
    @depth = depth
    reseed(seed)
  end

  #Set up a new seed value
  def reseed(seed=FibonacciRng.seed)
    @buffer = Array.new(@depth+2, 0)
    seedsrc = (seed.to_s + seed.class.to_s + 'Leonardo Pisano').each_byte.cycle
    indxsrc = (0...depth).cycle
    do_reseed(indxsrc, seedsrc)
  end

  #Roll a dice.
  def dice(sides)
    limit = ((CHOP+1) / sides) * sides

    begin
      do_spin
    end until @buffer[0] < limit

    @buffer[0] % sides
  end

  #Get a pseudo random byte
  def byte
    do_spin
    @buffer[0] & BYTE
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
