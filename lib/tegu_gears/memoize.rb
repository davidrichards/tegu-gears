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
      def call(*x)
        function(*x)
      end

      def memoize
        @memoize = defined?(@memoize) ? @memoize : true
      end

      def memoize=(val)
        @memoize = val ? true : false
      end

      # Has a global effect.  Any instance will keep their settings, and can
      # save their settings.  This is important for things that just shouldn't
      # be memoized, and we don't need to tell each instance that we're
      # playing the game differently:
      # 
      # class A
      #   include TeguGears
      #   nix_memos
      # end
      # def nix_memos
      #   self.class.memoize_default = false
      #   self.memoize = false
      # end
      # 
      # # Works the same as nix_memos, only turns memoization on.
      # def allow_memos
      #   self.class.memoize_default = true
      #   self.memoize = true
      # end

      def function(*x)
        val = (self.memoize ? memoized(*x) : process(*x))
        self.notify_observers(val)
        val
      end

      def memoized(*x)
        MemoRepository.for(self, x) || MemoRepository.set(self, x, process(*x))
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
