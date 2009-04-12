module TeguGears #:nodoc:
  # If I can get used to using a struct or a single input variable, I can
  # do things this way.  Otherwise, I need to get deeper into the meta
  # programming to work around how to call things in a signatureless
  # environment.  Not an easy nut to crack, btw. 
  module Memoize
    module ClassMethods
      def instance
        @inst ||= new
      end

      def method_missing(sym, *args, &block)
        instance.send(sym, *args, &block)
      end
    end

    module InstanceMethods
      def call(x)
        function(x)
      end

      def memoize
        @memoize = true unless defined?(@memoize)
        @memoize 
      end

      def memoize=(val)
        @memoize = val
      end

      def function(x)
        self.memoize ? memoized(x) : process(x)
      end

      def memoized(x)
        MemoRepository.for(self, x) || MemoRepository.set(self, x, process(x))
      end

      def flush
        MemoRepository.flush_for(self)
      end

    end

    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
    end
  end
  
end