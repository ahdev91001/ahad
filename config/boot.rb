ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Uncomment below to get load times for all gems when rails boots
# Code from: http://mildlyinternet.com/code/profiling-rails-boot-time.html
#=begin
require "benchmark"
require "pry-byebug"


def require(file_name)
  result = nil

  # look at caller object
  #if file_name == "rails/commands"
  #  binding.pry
  #end
  
  time = Benchmark.realtime do
    result = super
  end

  if time > 0.1
    puts "#{time} #{file_name}"
  end

  result
end
#=end
