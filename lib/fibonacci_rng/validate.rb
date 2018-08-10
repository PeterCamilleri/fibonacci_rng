# coding: utf-8

# The class of RNG errors.
class InvalidFibonacciRngState < RuntimeError; end

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  #Validate the sanity of the generator.
  def validate
    @buffer.each do |element| 
      return true unless element.zero?
    end
    
    fail InvalidFibonacciRngState
  end

end