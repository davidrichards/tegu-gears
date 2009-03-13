# Changes made to:
# * have a spawned process report its value
# * increment and decrement the spawn pool size
module NeverBlock
  module Pool

    # Author::    Mohammad A. Ali  (mailto:oldmoe@gmail.com)
    # Copyright:: Copyright (c) 2008 eSpace, Inc.
    # License::   Distributes under the same terms as Ruby
    #
    #	A pool of initialized fibers
    #	It does not grow in size or create transient fibers
    #	It will queue code blocks when needed (if all its fibers are busy)
    #
    # This class is particulary useful when you use the fibers 
    # to connect to evented back ends. It also does not generate
    # transient objects and thus saves memory.
    #
    # Example:
    # fiber_pool = NeverBlock::Pool::FiberPool.new(150)
    # 
    # loop do
    #   fiber_pool.spawn do
    #     #fiber body goes here 
    #   end
    # end
    #
    class FiberPool

      # gives access to the currently free fibers
      attr_reader :fibers
      
      # Prepare a list of fibers that are able to run different blocks of code
      # every time. Once a fiber is done with its block, it attempts to fetch
      # another one from the queue
      def initialize(count = 50)
        @fibers,@busy_fibers,@queue = [],{},[]
        count.times do |i|
          @fibers << generate_fiber
        end
      end

      # If there is an available fiber use it, otherwise, leave it to linger
      # in a queue
      def spawn(evented = true, &block)
        if fiber = @fibers.shift
          fiber[:callbacks] = []
          @busy_fibers[fiber.object_id] = fiber
          fiber[:neverblock] = evented
          val = fiber.resume(block)
          @fibers.delete(fiber) if fiber[:pending_delete]
        else
          @queue << block
        end
        self # we are keen on hiding our queue
      end
      
      # To spawn and setup a listening link, listeners must be an object or
      # array of objects that implement :receive with the value of the process.
      # So, something like: 
      # 
      # class Calculator
      #   attr_reader :pool
      #   def initialize(pool)
      #     @pool = pool
      #   end
      #   
      #   def receive(value)
      #     puts value
      #   end
      #   
      #   def add(a,b)
      #     self.pool.spawn_link(self) {a + b}
      #   end
      # end

      def spawn_link(listeners, evented=true, &block)
        if fiber = @fibers.shift
          fiber[:callbacks] = []
          fiber[:listeners] = listeners
          @busy_fibers[fiber.object_id] = fiber
          fiber[:neverblock] = evented
          val = fiber.resume(block)
          @fibers.delete(fiber) if fiber[:pending_delete]
        else
          @queue << block
        end
        fiber || self # we are keen on hiding our queue
      end
      
      # Adds n new fibers in the pool
      def increment(n=1)
        n.times do
          @fibers << generate_fiber
        end
      end
      
      # Removes n fibers from the pool, after they've finished their current
      # or next job (we don't try to interrupt ongoing work.  If something's
      # hanging or taking too long, that's a different problem.) 
      def decrement(n=1)
        n = @fibers.size if n > @fibers.size
        @fibers[0...n].each{|f| f[:pending_delete] = true}
      end
      
      # Sends the results back to the linked object.
      def send_results(listeners, value)
        if listeners.is_a?(Array)
          listeners.each {|l| l.send(:receive, value)}
        else
          listeners.send(:receive, value)
        end
      end
      protected :send_results
      
      def generate_fiber
        fiber = Fiber.new do |block|
          loop do
            value = block.call
            send_results(Fiber.current[:listeners], value) if Fiber.current[:listeners]

            # callbacks are called in a reverse order, much like c++ destructor
            Fiber.current[:callbacks].pop.call while Fiber.current[:callbacks].length > 0
            unless @queue.empty?
              block = @queue.shift
            else
              @busy_fibers.delete(Fiber.current.object_id)
              @fibers << Fiber.current
              block = Fiber.yield
            end
          end
        end
        fiber[:callbacks] = []
        fiber[:em_keys] = []
        fiber[:neverblock] = true
        fiber[:pending_delete] = false
        fiber
      end
      protected :generate_fiber

    end # FiberPool
  end # Pool
end # NeverBlock

