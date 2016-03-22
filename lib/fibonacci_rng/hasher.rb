# coding: utf-8

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  #Get the value of the rng state as a number.
  def hash_value
    result = 0
    @buffer[0...@depth].each {|value| result = (result << 29) + value }
    result
  end

  #Get the value of the rng state as a string.
  def hash_string
    hash_value.to_s(36)
  end

  #Append data to the generator
  def <<(data)
    (str = data.to_s).each_byte.each do |value|
      add_value(value)
    end

    do_spin if str.empty?
  end

  private

  #Add a value to the generator.
  def add_value(value)
    index = @buffer[0] % @depth
    do_spin
    @buffer[index] += value
    do_spin
  end

end
