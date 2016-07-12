# coding: utf-8

#* spinner.rb - Methods to churn the generator.
class FibonacciRng

  #Cycle through the PRNG count times.
  def spin(count=1)
    count.times do
      do_spin
    end
  end

  #Cycle through the PRNG once.
  #This method is now in ext/fibonacci_rng/fibonacci_rng.c
  #The original Ruby code follows to document what is done there.
  #This code is taken from the speed_up_one branch.

# def do_spin
#   @buffer[-2] = @buffer[0]
#   @buffer[-1] = p_one = @buffer[1]
#   (0...@depth).each do |idx|
#     p_two = @buffer[idx+2]
#     @buffer[idx] = (p_one + ((p_two >> 1) | (p_two.odd? ? TOP : 0))) & CHOP
#     p_one = p_two
#   end
# end

end
