# coding: utf-8

require_relative '../lib/fibonacci_rng'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class CoreTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_that_it_creates_dice_rolls
    prng = FibonacciRng.new

    100.times do
      assert((0...6) === prng.dice(6))
    end
  end

  def test_that_it_creates_bytes
    prng = FibonacciRng.new

    100.times do
      assert((0...256) === prng.byte)
    end
  end

  def test_that_it_creates_words
    prng = FibonacciRng.new

    100.times do
      assert((0...65536) === prng.word)
    end
  end

  def test_that_it_creates_floats
    prng = FibonacciRng.new

    100.times do
      value = prng.float
      assert((value >= 0.0) && (value < 1.0))
    end
  end

  def test_compatible_global_dice_rolls
    100.times do
      assert((0...6) === FibonacciRng.rand(6))
    end
  end

  def test_compatible_global_dice_rolls_range
    100.times do
      assert((0...6) === FibonacciRng.rand(0...6))
    end
  end

  def test_compatible_global_floats
    100.times do
      value = FibonacciRng.rand(0)
      assert((value >= 0.0) && (value < 1.0))
    end
  end

  def test_random_string
    prng = FibonacciRng.new

    rs = prng.bytes(10)

    assert(rs.is_a?(String))
    assert_equal(10, rs.length)
  end

  def test_that_it_makes_unique_sequnces
    prnga = FibonacciRng.new
    prngb = FibonacciRng.new

    buffa = []
    buffb = []

    100.times do
      buffa << prnga.dice(6)
      buffb << prngb.dice(6)
    end

    assert(buffa != buffb)
  end

  def test_that_it_makes_repeatable_sequnces
    prnga = FibonacciRng.new(0)
    prngb = FibonacciRng.new(0)

    buffa = []
    buffb = []

    100.times do
      buffa << prnga.dice(6)
      buffb << prngb.dice(6)
    end

    assert(buffa == buffb)
  end
end
