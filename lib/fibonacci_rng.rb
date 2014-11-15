require "fibonacci_rng/version"

class FibonacciRng
  CHOP = 0x3FFFFFFF
  BYTE = 0xFF
  WORD = 0xFFFF
  BASE = 1073741824.0

  #An accessor for the depth!
  attr_reader :depth

  #Initialize the PRN generator
  def initialize(depth=8, seed=Time.now.to_s)
    fail "Invalid depth value (3..30)." unless (3..30) === depth
    @depth = depth
    reseed(seed)
  end

  #Set up a new seed value
  def reseed(seed=Time.now.to_s)
    @buffer = Array.new(@depth+2, 0)
    seedsrc = (seed.to_s + seed.class.to_s + 'Leonardo Pisano').each_byte.cycle
    indxsrc = (0...depth).cycle

    1024.times do
      @buffer[indxsrc.next] += seedsrc.next
      do_spin
    end
  end

  #Roll a dice.
  def dice(sides)
    do_spin
    @buffer[0] % sides
  end

  #Get a pseudo random byte
  def byte
    do_spin
    @buffer[0] & BYTE
  end

  #Get a pseudo random word
  def byte
    do_spin
    @buffer[0] & WORD
  end

  #Get a pseudo random float
  def byte
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
  #Cycle through the PRNG once.
  def do_spin
    buffer[-2] = buffer[0]
    buffer[-1] = buffer[1]

    0...depth do |i|
      buffer[i] = (buffer[i+1] + (buffer[i+2] >> 1)) & CHOP
    end
  end

end
