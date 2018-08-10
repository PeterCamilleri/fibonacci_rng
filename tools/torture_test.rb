# coding: utf-8

#A Scatter Plot tester
class TortureTest

  #Run a scatter plot test on the random number generator.
  def run(gen, max, count)
    max   *=1000
    count *=1000

    puts "Starting torture test with #{max} loops of #{count} tests."

    max.times do |i|
      gen.spin(count)
      print (i+1).to_s.rjust(8)
    end

    puts
    puts "No errors were detected."
    return

    rescue InvalidFibonacciRngState
      puts
      puts "InvalidFibonacciRngState detected."
  end

end
