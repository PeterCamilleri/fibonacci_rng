# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fibonacci_rng/version'

Gem::Specification.new do |spec|
  spec.name          = "fibonacci_rng"
  spec.version       = FibonacciRng::VERSION
  spec.authors       = ["Peter Camilleri"]
  spec.email         = ["peter.c.camilleri@gmail.com"]
  spec.homepage      = "http://teuthida-technologies.com/"
  spec.description   = "A Fibonacci inspired pseudo random number generator. Just try and prove that it sucks! ;-)"
  spec.summary       = "A Fibonacci inspired pseudo random number generator."
  spec.license       = "MIT"

  raw_list = `git ls-files`.split($/)
  raw_list = raw_list.keep_if {|entry| !entry.start_with?("docs") }

  spec.files         = raw_list
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'minitest_visible', ">= 0.1.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'reek', "~> 1.3.8"
  spec.add_development_dependency 'minitest', "~> 4.7.5"
  spec.add_development_dependency 'rdoc', "~> 4.0.1"
end
