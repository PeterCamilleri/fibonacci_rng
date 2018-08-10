# coding: utf-8

#A Scatter Plot tester
class TortureTest

  #Run a scatter plot test on the random number generator.
  def run(gen, max, count)
    max   *=100
    count *=100

    puts "Starting torture test with #{max} of #{count} tests."

    max.times do |i|

      count.times do
        gen.dice(20)
      end

      print "#{i} "
    end

    puts
    puts "No errors were detected."
    return

    rescue InvalidFibonacciRngState
      puts
      puts "InvalidFibonacciRngState detected."
  end

end
