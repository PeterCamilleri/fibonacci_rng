# coding: utf-8

#* seeder.rb - Compute the initial seed state of the generator.
class FibonacciRng

  #Set up a new seed value
  def srand(seed=FibonacciRng.new_seed)
    @seed = seed
    @buffer = Array.new(@depth+2, 0)
    seedsrc = (seed.to_s + fudge(seed) + 'Leonardo Pisano').each_byte.cycle
    indxsrc = (0...depth).cycle
    do_reseed(indxsrc, seedsrc)
  end

  private

  #A patch for the seeder class name bug.
  #<br>Endemic Code Smells
  #* :reek:UtilityFunction
  def fudge(seed)
    if seed.is_a?(Integer)
      if (-1073741824..1073741823) === seed
        "Fixnum"
      else
        "Bignum"
      end
    else
      seed.class.to_s
    end
  end

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
      index = indxsrc.next
      add_data(index, seedsrc.next)
      do_spin
    end
  end

end