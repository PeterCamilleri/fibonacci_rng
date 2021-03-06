# coding: utf-8

#A Scatter Plot tester
class ScatterPlot

  #Run a scatter plot test on the random number generator.
  def run(gen, max, count)
    puts "Starting test"
    bins = Array.new(max * 2, 0)


    count.times do |i|
      bins[i] = [gen.dice(max)]
    end

    count.times do |i|
      bins[i] << gen.dice(max)
    end

    count.times do |i|
      puts "#{bins[i][0]}, #{bins[i][1]}"
    end

  end

end
