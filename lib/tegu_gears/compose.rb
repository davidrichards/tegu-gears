module TeguGears #:nodoc:
  
  module InstanceMethods
    
    # This allows me to compose two classes using TeguGears.
    def compose(f)
      lambda {|*args| f.call(self.call(*args))}
    end
    alias :| :compose
  end
end

class Object
  # Composes any number of functions.  The first argument is the input.
  # Use Struct if the argument list needs to be more expansive. 
  def compose(*args)
    param = args.shift
    args.inject {|composition, f| make_binomial_composition(composition, f)}.call(param)
  end
  
  def make_binomial_composition(f, g)
    lambda{|*args| g.call(f.call(*args))}
  end
  private :make_binomial_composition
end
