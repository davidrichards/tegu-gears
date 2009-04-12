module TeguGears #:nodoc:
  module InstanceMethods
    
    # This allows me to compose two classes using TeguGears.
    def compose(f)
      lambda {|*args| self.call(f.call(*args))}
    end
    alias :| :compose
  end
end

class Object
  # Composes any number of functions.  The last argument is the input.
  # Use Struct if the argument list needs to be more expansive. 
  def compose(*args)
    param = args.pop
    args.inject {|composition, f| make_binomial_composition(composition, f)}.call(param)
  end
  
  def make_binomial_composition(f, g)
    lambda{|*args| f.call(g.call(*args))}
  end
  private :make_binomial_composition
end
