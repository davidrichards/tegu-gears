require 'rubygems'
require 'gratr'
require 'modelling'

class Value
  include Modelling
  attributes :value => Proc.new {0.0}
end

class Value
  attr_accessor :value
  def initialize(value)
    @value = value.to_f
  end
end

class Beta < Value; end
class Vote < Value; end
class Income < Value; end
class Education < Value; end
class PartisanIdentification < Value; end
class NeighborhoodContext < Value; end

class Operator
  include TeguGears
  
  # Auto-collects the in-nodes, multiplying what should be multiplied
  def process
    
    args.inject { |sum, e| sum + e }
  end
end


class System
  class << self
    def instance
      @@instance ||= new
    end
  end
  
  attr_reader :graph
  def initialize
    @graph = GRATR::Digraph.new
  end
  
  def add_edge(a,b,w=nil)
    self.graph.add_edge!(a,b,w)
  end
  
  def method_missing(sym, *args, &block)
    self.graph.send(sym, *args, &block)
  end
end

class Object
  def method_missing(sym, *args, &block)
    System.instance.send(sym, *args, &block)
  end
end

# swap(old, new)