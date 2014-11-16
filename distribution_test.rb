# coding: utf-8

require 'fibonacci_rng'

class DistributionTest

  def initialize(bin_size)
    @max  = bin_size
    @bins = Array.new(bin_size, 0)
  end

  def run(count)
    puts "Starting test"
    prng = FibonacciRng.new

    count.times do
      @bins[prng.dice(@max)] += 1
    end

    puts "Test completed, results:"
    puts @bins
  end

end

bin_limits = (3..1000)
bin_size = ARGV[0].to_i

count_limits = (1..1000000)
count = ARGV[1].to_i

unless bin_limits === bin_size
  puts "Invalid or missing bin size parameter. #{bin_limits}"
  exit
end

unless count_limits === count
  puts "Invalid or missing count parameter. #{count_limits}"
  exit
end

DistributionTest.new(bin_size).run(count)
