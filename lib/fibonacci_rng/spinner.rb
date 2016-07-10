# coding: utf-8

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  #Cycle through the PRNG count times.
  def spin(count=1)
    count.times do
      do_spin
    end
  end

  #Cycle through the PRNG once.
  #This method is now in ext/fibonacci_rng/fibonacci_rng.c
  # def do_spin
  #   code removed.
end