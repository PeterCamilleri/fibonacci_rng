# coding: utf-8

#* hasher.rb - Methods that allow the generation of simple hashes.
class FibonacciRng

  #Get the value of the rng state as a number.
  def hash_value
    result = 0
    (0...@depth).each {|index| result = (result << 29) + get_data(index) }
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
    index = get_root % @depth
    do_spin
    add_data(index, value)
    do_spin
  end

end
