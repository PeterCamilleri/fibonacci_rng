# coding: utf-8

#A wrapper for the internal random number generator
class InternalRng

  #Roll the dice!
  def dice(sides)
    rand(sides)
  end

  #Get a float!
  def float
    rand(0)
  end

end