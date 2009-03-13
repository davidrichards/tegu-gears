# From http://pragdave.blogs.pragprog.com/pragdave/2008/01/pipelines-using.html
# This is a basic concept that I think would be a lot of fun to
# implement in various ways.  Instead of just walking all over the whole
# environment, use a class explicitly that can handle chaining, Fibers,
# etc. 
class PipelineElement

  attr_accessor :source
  attr_reader :fiber_delegate

  def initialize(&block)
    @transformer    = block
    @transformer    ||= method(:transform)
    @filter         ||= method(:filter)
    @fiber_delegate = Fiber.new do
      process
    end
  end

  def |(other=nil, &block)
    other = Transformer.new(&block) if block
    other.source = self
    other
  end

  def resume
    @fiber_delegate.resume
  end
  alias :run :resume

  def process
    while value = input
      handle_value(value)
    end
  end

  def input
    source.resume
  end

  def output(value)
    Fiber.yield(value)
  end

  def handle_value(value)
    output(@transformer.call(value)) if @filter.call(value)
  end

  def transform(value)
  value
    end

  def filter(value)
    true
  end
end

# A transformer is a normal process that can be composed.
class Transformer < PipelineElement
  def initialize(&block)
    @transformer = block
    super
  end
end

# Filter ends a process unless the filter evaluates to true.
class Filter < PipelineElement
  def initialize(&block)
    @filter = block
    super
  end
end

# A Selector is used for finding set membership from the output of an algorithm.  For instance, if the new value is This is useful for adding unnamed parameters to your execution block.  Often a selector needs a threshold number.  
class Selector < PipelineElement
  def initialize(*params, &block)
    @transformer = block
    @params = params
  end
end

