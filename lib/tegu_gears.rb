require 'rubygems'
gem 'activesupport'
require 'activesupport'
require 'amqp'

# I need UUID for several reasons.
gem 'uuid'
require 'uuid'
# Maybe adds a little performance if we call this often.
class UUID
  def self.instance
    @@uuid_singleton ||= new
  end
end

# Add to these if you want to add class and instance methods.
module TeguGears
  module InstanceMethods; end
  module ClassMethods; end
end

$:.unshift(File.dirname(__FILE__))
require 'tegu_gears/memoize'
Dir.glob("#{File.dirname(__FILE__)}/tegu_gears/*.rb").each { |file| require file }
module TeguGears
  def self.included(base)
    base.send(:include, Memoize)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
    base.send(:include, TeguObservable)
  end
end

# Now that I have some tools setup, require some libraries that will be
# generally useful. This will be migrated to a configurable load process
# at some point soon. 

# Requires libraries, only if they're available.
def safe_load(val=nil, &block)
  begin
    if block
      block.call
    else
      require val
    end
  # Very important that this is Exception, and not StandardError
  rescue Exception => e 
    false
  end
end

safe_load 'rubygems'
safe_load 'mathn'
safe_load {require bigdecimal; require 'bigdecimal/math'}
safe_load 'set'
safe_load 'matrix'
safe_load 'narray'
safe_load 'rnum'
safe_load 'gratr'
safe_load 'tenacious_g'
safe_load 'rbtree'

# Require the examples too, they are meant to be generally interesting or useful.
Dir.glob("#{File.dirname(__FILE__)}/examples/*.rb").each { |file| require file }
