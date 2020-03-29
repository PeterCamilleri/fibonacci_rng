# coding: utf-8

require_relative '../lib/fibonacci_rng'
gem              'minitest'
require          'minitest/autorun'

#Test the monkey patches applied to the Object class.
class FibonacciRngTester < Minitest::Test

  def test_how_we_build_generators
    gen = FibonacciRng.new
    assert(gen.validate)
    assert_equal(8, gen.depth)
    assert_equal(String, gen.seed.class)
    assert_equal(1024, gen.init)
    assert(gen.validate)

    gen = FibonacciRng.new('seed')
    assert(gen.validate)
    assert_equal(8, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1024, gen.init)
    assert(gen.validate)

    gen = FibonacciRng.new('seed', 12)
    assert(gen.validate)
    assert_equal(12, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1152, gen.init)
    assert(gen.validate)

    gen = FibonacciRng.new('seed', 12, 2048)
    assert(gen.validate)
    assert_equal(12, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(2048, gen.init)
    assert(gen.validate)
  end

  def test_building_with_keywords
    gen = FibonacciRng.new(seed: 'seed')
    assert(gen.validate)
    assert_equal(8, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1024, gen.init)
    assert(gen.validate)

    gen = FibonacciRng.new(depth: 12)
    assert(gen.validate)
    assert_equal(12, gen.depth)
    assert_equal(String, gen.seed.class)
    assert_equal(1152, gen.init)
    assert(gen.validate)

    gen = FibonacciRng.new(seed: 'seed', depth: 12)
    assert(gen.validate)
    assert_equal(12, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1152, gen.init)
    assert(gen.validate)

    gen = FibonacciRng.new(depth: 12, seed: 'seed')
    assert(gen.validate)
    assert_equal(12, gen.depth)
    assert_equal('seed', gen.seed)
    assert_equal(1152, gen.init)
    assert(gen.validate)

    gen = FibonacciRng.new(seed: 'seed', init: 2048)
    assert(gen.validate)
    assert_equal('seed', gen.seed)
    assert_equal(2048, gen.init)
    assert(gen.validate)
  end

  def test_that_it_detects_fatal_conditions
    gen = FibonacciRng.new
    assert(gen.validate)

    gen.define_singleton_method(:kill) do
      @buffer = Array.new(@buffer.length, 0)
    end

    gen.kill #Force a fatal error condition.

    assert_raises(InvalidFibonacciRngState) {gen.validate}
    assert_raises(InvalidFibonacciRngState) {gen.spin(6)}
    assert_raises(InvalidFibonacciRngState) {gen.dice(6)}
    assert_raises(InvalidFibonacciRngState) {gen.byte}
    assert_raises(InvalidFibonacciRngState) {gen.word}
    assert_raises(InvalidFibonacciRngState) {gen.float}
    assert_raises(InvalidFibonacciRngState) {gen.double}

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

    rng = FibonacciRng.new("%s*08^_Tg{NnirtZ-94)q9z2l+~bB5")
    assert_equal(",-+Idi6~ ~", rng.string(10))
    assert_equal('5901964804', rng.string(10, '0123456789'))
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

    prng.reseed("%s*08^_Tg{NnirtZ-94)q9z2l+~bB5")
    result = Array.new(80) { prng.byte }
    assert_equal(expected, result)


    expected = [0.466758593916893,    0.8060004059225321,
                0.8063845634460449,   0.8676037490367889,
                0.350975576788187,    0.2556227296590805,
                0.4873242452740669,   0.07484667748212814,
                0.2968141995370388,   0.5417192056775093,
                0.4288134817034006,   0.26460993848741055,
                0.13613684102892876,  0.27074786089360714,
                0.11685592867434025,  0.814235333353281,
                0.6137734726071358,   0.9152738898992538,
                0.6325213424861431,   0.22782298550009727,
                0.6877559795975685,   0.9354030545800924,
                0.18385234475135803,  0.5579136144369841,
                0.7501311469823122,   0.04208622872829437,
                0.31922253780066967,  0.6471036206930876,
                0.4305369835346937,   0.2239683922380209,
                0.9770196247845888,   0.3727417625486851]

    prng.reseed("%s*08^_Tg{NnirtZ-94)q9z2l+~bB5")
    result = Array.new(32) { prng.float }
    #assert_equal(expected, result)

    (0...32).each do |i|
      assert_in_delta(expected[i], result[i], 1.0e-16)
    end

    expected = [0.46675859541818576,  0.8063845650620829,
                0.3509755772643215,   0.48732424541347974,
                0.29681420054606944,  0.428813482196275,
                0.13613684153323594,  0.11685593019097174,
                0.6137734743119663,   0.6325213429104964,
                0.6877559813398925,   0.18385234579055312,
                0.7501311470607039,   0.31922253900599407,
                0.43053698395186735,  0.9770196254788744,
                0.105776653432334,    0.17992045162625886,
                0.7068137351637119,   0.09374992924495854,
                0.4741257221497737,   0.2717329622804037,
                0.6427948478921109,   0.048162101812947195,
                0.649627174383166,    0.27438020721066836,
                0.9478733559036244,   0.6199505789910625,
                0.8043054302444751,   0.9363898295339244,
                0.6613804354420972,   0.5876014495519649]

    prng.reseed("%s*08^_Tg{NnirtZ-94)q9z2l+~bB5")
    result = Array.new(32) { prng.double }
    #assert_equal(expected, result)

    (0...32).each do |i|
      assert_in_delta(expected[i], result[i], 1.0e-16)
    end

  end

end
