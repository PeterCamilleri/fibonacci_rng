# coding: utf-8

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  #Cycle through the PRNG count times.
  def spin(count=1)
    count.times do
      do_spin
    end
  end

  private

  #Cycle through the PRNG once.
  def do_spin
    @buffer[-2] = @buffer[0]
    @buffer[-1] = @buffer[1]

    (0...@depth).each do |idx|
      @buffer[idx] = (@buffer[idx+1] + (@buffer[idx+2] >> 1)) & CHOP
    end
  end

end