# coding: utf-8

require_relative '../lib/fibonacci_rng'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

#Test the monkey patches applied to the Object class.
class FibonacciRngTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_how_we_build_generators
    gen = FibonacciRng.new
    assert_equal(8, gen.depth)
    assert_equal(String, gen.seed.class)
    assert_equal(1024, gen.init)

    gen = FibonacciRng.new('seed')
    assert_equal(8, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1024, gen.init)

    gen = FibonacciRng.new('seed', 12)
    assert_equal(12, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1152, gen.init)

    gen = FibonacciRng.new('seed', 12, 2048)
    assert_equal(12, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(2048, gen.init)
  end

  def test_building_with_keywords
    gen = FibonacciRng.new(seed: 'seed')
    assert_equal(8, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1024, gen.init)

    gen = FibonacciRng.new(depth: 12)
    assert_equal(12, gen.depth)
    assert_equal(String, gen.seed.class)
    assert_equal(1152, gen.init)

    gen = FibonacciRng.new(seed: 'seed', depth: 12)
    assert_equal(12, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1152, gen.init)

    gen = FibonacciRng.new(depth: 12, seed: 'seed')
    assert_equal(12, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1152, gen.init)

    gen = FibonacciRng.new(seed: 'seed', init: 2048)
    assert_equal('seed', gen.seed)
    assert_equal(2048, gen.init)
  end

  def test_that_rejects_bad_parms
    assert_raises { FibonacciRng.new('seed', 1) }
    assert_raises { FibonacciRng.new('seed', 65536) }
  end

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

  def test_that_it_makes_unique_sequences
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

  def test_that_it_makes_repeatable_sequences
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

  def test_that_it_creates_unique_seeds
    result = []
    10_000.times do
      result << FibonacciRng.new_seed
    end

    result.uniq!
    assert_equal(10_000, result.length)
  end

  def test_building_strings
    rng = FibonacciRng.new(0)

    assert_equal("c}l'(q@g\\z", rng.string(10))
    assert_equal('2727573312', rng.string(10, '0123456789'))
    assert_equal('khto lk si', rng.string(10, 'Always look on the bright side of life.'))
  end

  def test_for_data_stability
    #Make sure incompatibilities do not creep in.
    expected = [184,  93,   0, 240,  34, 184,   4, 220, 126, 132,
                 13,  67, 166, 107, 165,  66,  68, 120, 102, 110,
                212,  99,  80, 167,   9,  56,  47, 167, 127, 195,
                169,  34, 184,  97, 136, 176, 214, 104, 218, 103,
                180,  16,  83, 204, 128,  81,  63,  56, 237, 165,
                  0,  88, 129,  40, 152,  44, 189,  35, 205, 249,
                 77,  94, 142,  18,  60, 248,  49, 172, 235,  83,
                 84,  65, 181, 117,  16, 170, 222,  97, 130, 217]

    prng = FibonacciRng.new("%s*08^_Tg{NnirtZ-94)q9z2l+~bB5")
    result = Array.new(80) { prng.byte }

    assert_equal(expected, result)

    expected = [0.34260736405849457, 0.1141757033765316,   0.8017844762653112,
                0.5771869346499443,  0.9653580263257027,   0.49920978024601936,
                0.932930888608098,   0.006505902856588364, 0.8475628644227982,
                0.3483570497483015,  0.40469503588974476,  0.8303383085876703,
                0.1717253141105175,  0.8908081632107496,   0.45995678193867207,
                0.02826204150915146, 0.505797715857625,    0.005863353610038757,
                0.9807986635714769,  0.5360144283622503,   0.3335073571652174,
                0.6268878690898418,  0.31655459851026535,  0.8280083928257227,
                0.45514218881726265, 0.7138579320162535,   0.7108132243156433,
                0.1257183849811554,  0.2877823580056429,   0.3349035494029522,
                0.07588007673621178, 0.8433798849582672,   0.4158966913819313,
                0.46831064485013485, 0.31348903849720955,  0.9736821111291647,
                0.26395089365541935, 0.7052847743034363,   0.8090815804898739,
                0.04703875072300434, 0.46031793765723705,  0.7791291400790215,
                0.2181396260857582,  0.7659928575158119,   0.9803028162568808,
                0.08270183578133583, 0.5765040181577206,   0.061894554644823074]

    result = Array.new(48) { prng.float }

    (0...48).each do |i|
      assert_in_delta(expected[i], result[i], 1.0e-16)
    end

  end

end
