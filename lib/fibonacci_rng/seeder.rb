# coding: utf-8

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  #Set up a new seed value
  def srand(seed=FibonacciRng.new_seed)
    @seed = seed
    @buffer = Array.new(@depth, 0)
    seedsrc = (seed.to_s + seed.class.to_s + 'Leonardo Pisano').each_byte.cycle
    indxsrc = (0...depth).cycle
    do_reseed(indxsrc, seedsrc)
  end

  private

  #A class instance variable to hold the tickle value.
  @tickle = '0'

  #A synchronizer for access to the @tickle variable
  @sync = Mutex.new

  #Create the default seed string.
  def self.new_seed
    @sync.synchronize {Time.now.to_s + @tickle.succ!}
  end

  #Do the work of reseeding the PRNG
  def do_reseed(indxsrc, seedsrc)
    @init.times do
      @buffer[indxsrc.next] += seedsrc.next
      do_spin
    end
  end

end