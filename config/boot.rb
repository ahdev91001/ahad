ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require "benchmark"

def require(file_name)
  result = nil

  time = Benchmark.realtime do
    result = super
  end

  if time > 0.1
    puts "#{time} #{file_name}"
  end

  result
end