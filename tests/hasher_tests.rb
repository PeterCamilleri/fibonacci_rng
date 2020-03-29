# coding: utf-8

require_relative '../lib/fibonacci_rng'
gem              'minitest'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class FibonacciHasherTester < Minitest::Test

  def test_that_it_can_be_read
    fib = FibonacciRng.new('salt')

    val = 6283409396933018229308310224792996722092866776518016470611172637516158
    assert_equal(val, fib.hash_value)

    str = 'kxoj5k4rx6mqx1bmskx2133lrr21h8l2fs0zd1ver0ozi'
    assert_equal(str, fib.hash_string)
  end

  def test_that_data_can_be_added_to_it
    fib = FibonacciRng.new('salt')

    fib << "The quick brown fox jumps over the lazy dog."

    str = 'hoeh45h3fqlrgnynud0rg3v8q62cadr9gmxx9lomzo3hi'
    assert_equal(str, fib.hash_string)

    fib << nil

    refute_equal(str, fib.hash_string)
    str = '9anamtuoyhhb7v6s7y70m31mfsl2r2rbp4vki0vb9rnag'
    assert_equal(str, fib.hash_string)
  end

end