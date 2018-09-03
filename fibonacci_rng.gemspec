# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fibonacci_rng/version'

Gem::Specification.new do |spec|
  spec.name          = "fibonacci_rng"
  spec.version       = FibonacciRng::VERSION
  spec.authors       = ["Peter Camilleri"]
  spec.email         = ["peter.c.camilleri@gmail.com"]
  spec.homepage      = "https://github.com/PeterCamilleri/fibonacci_rng"
  spec.description   = "A Fibonacci inspired pseudo random number generator " +
                       "with error detection."
  spec.summary       = "A Fibonacci inspired pseudo random number generator."
  spec.license       = "MIT"

  raw_list = `git ls-files`.split($/)
  raw_list = raw_list.keep_if {|entry| !entry.start_with?("docs") }

  spec.files         = raw_list
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'minitest', "~> 5.7"
  spec.add_development_dependency 'minitest_visible', "~> 0.1"
  spec.add_development_dependency 'rdoc', "~> 5.0"
  spec.add_development_dependency 'reek', "~> 4.5"

end
