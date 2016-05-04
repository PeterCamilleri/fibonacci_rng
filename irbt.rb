# coding: utf-8
# An IRB + fibonacci_rng Test bed

require 'irb'
$force_alias_read_line_module = true
require 'mini_readline'

puts "Starting an IRB console with fibonacci_rng loaded."

if ARGV[0] == 'local'
  require_relative 'lib/fibonacci_rng'
  puts "fibonacci_rng loaded locally: #{FibonacciRng::VERSION}"

  ARGV.shift
else
  require 'fibonacci_rng'
  puts "fibonacci_rng loaded from gem: #{FibonacciRng::VERSION}"
end

IRB.start
