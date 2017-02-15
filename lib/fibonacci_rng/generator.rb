# coding: utf-8

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  #A (mostly) compatible access point for random numbers.
  #<br>Endemic Code Smells
  #* :reek:FeatureEnvy
  def rand(max=0)
    if max.is_a?(Range)
      min = max.min
      dice(1 + max.max - min) + min
    elsif max.zero?
      float
    else
      dice(max.to_i)
    end
  end

  #Roll a dice.
  def dice(sides)
    limit = ((CHOP+1) / sides) * sides

    begin
      do_spin
    end until (value = @buffer[0]) < limit

    value % sides
  end

  #Get a pseudo random byte
  def byte
    do_spin
    @buffer[0] & BYTE
  end

  #Get a string of random bytes
  def bytes(length)
    result = ""
    length.times {result << byte.chr}
    result
  end

  #Get a pseudo random word
  def word
    do_spin
    @buffer[0] & WORD
  end

  #Get a pseudo random float
  def float
    do_spin
    raw_float / BASE
  end

  #Get a better pseudo random float
  def double
    do_spin
    part_one = raw_float * BASE
    do_spin
    (part_one + raw_float) / DOUBLE
  end

  #The printable seven bit ASCII characters.
  ASCII_7_BIT = (' '..'~').to_a.join.freeze

  #Create a random string
  #<br>Endemic Code Smells.
  #* :reek:FeatureEnvy
  def string(length, set=ASCII_7_BIT)
    set_length = set.length
    result = ""
    length.times {result << set[dice(set_length)]}
    result
  end

  private

  #Get a float value.
  def raw_float
    @buffer[0].to_f
  end

end
