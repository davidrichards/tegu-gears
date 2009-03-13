module TeguGears #:nodoc:
  # This is the shared information that everythign in a process will use:
  # fiber pool, node pool, etc. 
  class Shared
    class << self
      def pool
        @pool ||= NB::Pool::FiberPool.new(30)  
      end
      
      def spawn(&block)
        self.pool.spawn(&block)
      end
      
      # Puts an operation on the Starling work queue and gets taken up by a
      # Fiber pool on some machine.  The results are published on the results
      # queue. 
      def queue(&block)
      end
      
    end
  end
end