# coding: utf-8

#* generator.rb - The data generation methods.
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
    end until (value = get_root) < limit

    value % sides
  end

  #Get a pseudo random byte
#  def byte
#    do_spin
#    get_root & BYTE
#  end

  #Get a string of random bytes
  def bytes(length)
    result = ""
    length.times {result << byte.chr}
    result
  end

  #Get a pseudo random word
  def word
    do_spin
    get_root & WORD
  end

  #Get a pseudo random float
  def float
    do_spin
    get_root.to_f / BASE
  end

  #The printable seven bit ASCII characters.
  ASCII_7_BIT = (' '..'~').to_a.join

  #Create a random string
  #<br>Endemic Code Smells.
  #* :reek:FeatureEnvy
  def string(length, set=ASCII_7_BIT)
    set_length = set.length
    result = ""
    length.times {result << set[dice(set_length)]}
    result
  end

end
