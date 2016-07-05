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
    @buffer[-2]         = @buffer[0]
    @buffer[-1] = p_one = @buffer[1]

    (0...@depth).each do |idx|
      p_two = @buffer[idx+2]
      @buffer[idx] = (p_one + ((p_two >> 1) | (p_two.odd? ? TOP : 0))) & CHOP
      p_one = p_two
    end
  end

end