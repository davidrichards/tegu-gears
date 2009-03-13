require File.join(File.dirname(__FILE__), %w(.. lib tegu_gears))

module Composition #:nodoc:
  
  class IntegerEmitter < PipelineElement
    def process
      value = 0
      loop do
        output(value)
        value += 1
      end
    end
  end
  
  module_function
    def emitter
      @emitter ||= Emitter.new
    end
    
    def doubler
      @doubler ||= Transformer.new {|x| x * 2}
    end
  end
  
end
# Make sure the Shared stuff is available generally
# adder = Transformer.new {||...}
# Add some more ideas here, compose a bunch of things and run them without the pool