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

    require 'fibonacci_rng'

Then in an appropriate place in the code:

    @my_rng = FibonacciRng.new(depth, seed_value)

Where
To get some data out here are some options:

    @my_rng.dice(100)    # A "random" integer between 0 and 99
    @my_rng.byte         # A "random" integer between 0 and 255
    @my_rng.word         # A "random" integer between 0 and 65535
    @my_rng.long         # A "random" integer between 0 and 4294967295
    @my_rng.float        # A "random" float between 0.0 and less than 1.0

also available

    @my_rng.reseed(new_seed_value)

I more than one stream of numbers is required, it is best to use multiple
instances of FibonacciRng objects rather than rely on one.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
