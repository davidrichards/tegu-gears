module TeguGears #:nodoc:
  
  # Should get more sophisticated with a configuration tool at some point.
  REPOSITORY_CLASS = Hash
  
  # This works like a pass through to other caching tools, or keeps things
  # in a hash.  Each class hosting TeguGear has its own entry in this
  # repository, as does each composition.  Other caching tools may be
  # useful to monitor the cache size, distribute it, or reduce different
  # kinds of caching. I use a key/value interface, because that should
  # work well with Memcache, Tokyo Cabinet, Redis, Hash, CouchDB, and
  # other tools. 
  # 
  # I refactored to a centrally-managed repository because distributed
  # caching doesn't make sense for expensive computations.  There's
  # probably another abstraction available that will allow distributed
  # caching only when configured, but I'll get to that when I write a
  # configuration harness. 
  class MemoRepository
    
    class << self
      def instance
        @@instance ||= new(REPOSITORY_CLASS.new)
      end
      
      def method_missing(sym, *args, &block)
        instance.send(sym, *args, &block)
      end
    end

    attr_reader :store
    def initialize(store=Hash.new)
      @store = store
    end
    
    def method_missing(sym, *args, &block)
      self.store.send(sym, *args, &block)
    end
    
    # Expects a hash on the other end, for now.
    def set(caller, key, value)
      key = simplify_key(key)
      self.store[caller] ||= REPOSITORY_CLASS.new
      self.store[caller][key] = value
    end
    
    # Because I opened things up to accept an array of params instead of a single param.
    def simplify_key(key)
      (key.is_a?(Array) and key.size == 1) ? key.first : key
    end
    protected :simplify_key
    
    def for(caller, key=nil)
      self.store[caller] ||= REPOSITORY_CLASS.new
      key ? self.store[caller][key] : self.store[caller]
    end
    
    def flush_for(caller)
      self.store[caller] = REPOSITORY_CLASS.new
    end
    
  end
end