# coding: utf-8

class AutoCorrelator

  #Run a auto correlation test on the random number generator.
  def run(gen, _width, count)
    data   = Array.new(2*count) { gen.float - 0.5}
    result = Array.new(count)

    (0..count).each do |lag|
      result[lag] = correlate(data, count, lag)
    end

    puts result

  end

  #Perform a single correlation
  def correlate(data, count, lag)
    result = 0.0

    (0...count).each do |idx|
      result += data[idx] * data[idx+lag]
    end

    result
  end

end