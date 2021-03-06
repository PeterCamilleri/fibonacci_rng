#!/usr/bin/env rake
# coding: utf-8

require "bundler/gem_tasks"
require 'rake/testtask'

#Run the Fibonacci unit test suite.
Rake::TestTask.new do |t|
  #List out all the test files.
  t.test_files = FileList['tests/**/*.rb']
  t.verbose = false
end

desc "Run a scan for smelly code!"
task :reek do |t|
  `reek --no-color lib > reek.txt`
end

desc "Run an IRB Session with fibonacci_rng loaded."
task :console do
  system "ruby irbt.rb local"
end

desc "What version of the Fibonacci is this?"
task :vers do |t|
  puts
  puts "Fibonacci random number generator version = #{FibonacciRng::VERSION}"
end

