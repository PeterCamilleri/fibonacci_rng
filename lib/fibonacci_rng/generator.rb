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

  #[Deprecated] Get a string of random bytes
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
    @buffer[0].to_f / BASE
  end

end
