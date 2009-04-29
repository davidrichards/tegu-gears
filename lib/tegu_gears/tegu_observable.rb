module TeguGears #:nodoc:
  
  # Since I can theoretically observe across threads, processes, and
  # machines, I'm implementing my own Observer pattern.  It looks basic
  # today, but will be updated as I add concurrency and distributed
  # processing to TeguGears. 
  module TeguObservable
    def observers
      @observers ||= {}
    end
    
    # observer is either an object that responds to update or the name of a
    # block.  We allow named blocks to remove the observer later if desired.
    # An anonymous, unique observer name is created if one isn't provided. 
    def add_observer(observer=nil, &block)
      raise ArgumentError, "Must provide a block or an object to receive messages." unless observer || block
      observer = assert_observer(observer)
      observers[observer] =  block_given? ? block : observer
      observer
    end

    def assert_observer(observer=nil)
      return observer || UUID.instance.generate
    end
    private :assert_observer
    
    def delete_observer(observer)
      observers.delete(observer)
    end
    
    def notify_observers(val=self)
      observers.each do |key, observer|
        notify_observer(observer, val)
      end
    end

    def notify_observer(observer, val=self)
      observer.is_a?(Proc) ? observer.call(val) : observer.update(val)
    end
    
    def uuid_regex
      /[\d|\w]{8}-[\d|\w]{4}-[\d|\w]{4}-[\d|\w]{4}-[\d|\w]{12}/
    end
    private :uuid_regex
    
    # Returns the blocks directly.
    def anonymous_observers
      self.observers.inject([]) {|sum, e| sum << e.last if e.first =~ uuid_regex; sum}
    end
 
  end
end