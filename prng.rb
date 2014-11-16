# coding: utf-8

#The Pseudo Random Number Generation Test Suite.
module PrngTestSuite

  #Display usage info and exit
  def self.usage(msg=nil)
    puts
    puts "PrngTestSuite Version 0.0.2"

    if msg
      puts
      puts msg
    end

    puts
    puts "Usage Info:"
    puts
    puts "$ ruby prng.rb <locn> <gen> <test> <max> <count>"
    puts
    puts "Where:"
    puts "  <locn>  fib code location, either 'gem' or 'local'"
    puts "  <gen>   select a generator, either 'fib' or 'int'"
    puts "  <test>  select a test, either 'chisq' or 'auto'"
    puts "  <max>   the number of bins to test    (2..65535)"
    puts "  <count> the number of samples to test (1..1000000)"
    puts

    exit
  end

end

if ARGV[0] == 'gem'
  require 'fibonacci_rng'
elsif ARGV[0] == 'local'
  require_relative 'lib/fibonacci_rng'
elsif ARGV[0] == 'help'
  PrngTestSuite.usage
else
  PrngTestSuite.usage "Error: missing or invalid locn parameter."
end

require_relative 'tools/internal_rng'
require_relative 'tools/chi_squared'

module PrngTestSuite

  def self.main
    if ARGV[1] == 'fib'
      gen = FibonacciRng.new
    elsif ARGV[1] == 'int'
      gen = InternalRng.new
    else
      PrngTestSuite.usage "Error: missing or invalid gen parameter."
    end

    if ARGV[2] == 'chisq'
      tester = ChiSquaredTest.new
    elsif ARGV[2] == 'auto'
      tester = nil #not written yet!
    else
      PrngTestSuite.usage "Error: missing or invalid test parameter."
    end

    unless (2..65535) === (max = ARGV[3].to_i)
      PrngTestSuite.usage "Error: missing or invalid max parameter."
    end

    unless (1..10000000) === (count = ARGV[4].to_i)
      PrngTestSuite.usage "Error: missing or invalid count parameter."
    end

    tester.run(gen, max, count)
  end
end

PrngTestSuite.main
