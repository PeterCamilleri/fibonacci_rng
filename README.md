# FibonacciRng

This gem implements a random number generator inspired by the famous Fibonacci
number sequence. This is meant to serve as an example of a lesser or poorly
implemented random number generator. Until now, the linear congruential and
middle squares generators have been picked on as poor, so I felt that a new
contender was required. Proving that this is indeed a poor RNG is left as an
exercise for the reader!

## Installation

Add this line to your application's Gemfile:

    gem 'fibonacci_rng'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fibonacci_rng

## Usage

```ruby
require 'fibonacci_rng'
```

Then in an appropriate place in the code:

```ruby
@my_rng = FibonacciRng.new(depth, seed_value)
```

Where depth is an optional integer value between 2 and 99 and the seed value
is a number or string or other object that has a repeatable value. You can
also get a "random" generator of the default depth (8) and a randomized
seed. Here is an overview of the available options.

```ruby
@my_rng = FibonacciRng.new                            # Random seed, depth = 8
```

```ruby
@my_rng = FibonacciRng.new(seed)                      # Specified seed, depth = 8
```

```ruby
@my_rng = FibonacciRng.new(seed, 12)                  # Specified seed, depth = 12
```

```ruby
@my_rng = FibonacciRng.new(FibonacciRng.new_seed, 12) # Random seed, depth = 12

```

To get some data out here are some options:

```ruby
@my_rng.dice(100)     # A "random" integer between 0 and 99
@my_rng.byte          # A "random" integer between 0 and 255
@my_rng.word          # A "random" integer between 0 and 65535
@my_rng.float         # A "random" float between 0 and less than 1.
```

and also available

```ruby
@my_rng.reseed(value) # Reseed the sequence with the new value.
@my_rng.reseed        # Reseed the sequence with a "random" seed.
@my_rng.spin(count)   # Spin the generator count times.
@my_rng.spin          # Spin the generator once.
```

If more than one stream of numbers is required, it is best to use multiple
instances of FibonacciRng objects rather than rely on one. This will help avoid
the two streams of data being correlated.

### Hashing

As more as an experiment than anything else, it is also possible to use
the generator as a primitive hash generator. To do so, create a new
generator with a salt value, append data to it, and the retrieve the results
as a (big) number or a string.

```ruby
fib = FibonacciRng.new('salt')
fib << "The quick brown fox jumps over the lazy dog."
puts fib.hash_string
#displays: j5jqhk7ntrze02icv38gj28efa2qrctr6mi5ejbr2p4nj
```
Note that the length of the hash string is a function of the depth of the
generator used to create it. This is about 5.5 characters per unit of depth.

### Salting

Another (more practical) use for the Fibonacci generator is the creation of
salting strings for use in more capable hashing schemes. Here are three possible
ways that this can be done:

```ruby
salt_string = FibonacciRng.new.hash_string
```

```ruby
salt_string = FibonacciRng.new(FibonacciRng.new_seed, 12).hash_string
```

```ruby
@generator = FibonacciRng.new

# Much intervening code omitted.

@generator << Time.now.to_s  # Note that unique time values are NOT needed.
salt_string = @generator.hash_string
```
Each time any of these is run, a different salt string will be generated.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
