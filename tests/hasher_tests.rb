# coding: utf-8

require_relative '../lib/fibonacci_rng'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class FibonacciHasherTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_that_it_can_be_read
    fib = FibonacciRng.new('salt')

    val = 6419946790796257801349293118951652810485853780437507149800008378866623
    assert_equal(val, fib.hash_value)

    str = 'le247zggdghf5vpcjbw2hrjf9eu8ql01wvl1fhv14bykf'
    assert_equal(str, fib.hash_string)
  end

  def test_that_data_can_be_added_to_it
    fib = FibonacciRng.new('salt')

    fib << "The quick brown fox jumps over the lazy dog."

    str = 'j5jqhk7ntrze02icv38gj28efa2qrctr6mi5ejbr2p4nj'
    assert_equal(str, fib.hash_string)

    fib << nil

    refute_equal(str, fib.hash_string)
    str = '1g5sgt443g4jcn3bfpiee1fkqoklo0i1ctkjro2vevpp0'
    assert_equal(str, fib.hash_string)
  end

end