# Force load Logger before ActiveSupport's thread safety module
require 'logger'

module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger
  end
end