require 'rubygems'
gem 'activesupport'
require 'activesupport'

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
  end
end


# Require the examples too, they are meant to be generally interesting or useful.
Dir.glob("#{File.dirname(__FILE__)}/examples/*.rb").each { |file| require file }


