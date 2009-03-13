module TeguGears #:nodoc:
  require 'rubygems'
  require 'neverblock'
  require 'starling'
  
end

Dir.glob("#{File.dirname(__FILE__)}/overrides/*.rb").each { |file| require file }
Dir.glob("#{File.dirname(__FILE__)}/tegu_gears/*.rb").each { |file| require file }

include TeguGears