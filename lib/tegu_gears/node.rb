require 'pstore'

module TeguGears #:nodoc:
  class Node
    
    module PStoreMethods #:nodoc:
      def pstore
        @pstore ||= PStore.new(pstore_location)
      end
      
      def pstore_location
        @pstore_location ||= File.expand_path(File.join(ENV['HOME'], '.tegu_gears'))
      end
      
      def pstore_find(location)
        pstore.transaction { pstore[location] }
      end
      
      def pstore_save(node)
        pstore.transaction { pstore[node.location] = node }
      end
    
    end
    
    class << self
      include PStoreMethods
      
      # To use this, you must use register instead of new.  It allows us to
      # either find a previously defined node, or define a new one.  This is
      # because the state of the node will evolve over time, and we don't want
      # to lose that history. 
      def register(location)
        pstore_find(location) || new(location)
      end
      private :new
      
      # Builds a new hash locally to show all nodes that have been saved
      def nodes
        pstore.transaction do
          pstore.roots.inject({}) do |h, r|
            h[r] = pstore[r]
            h
          end
        end
      end
      
      # Takes either a regular expression that matches locations or a block
      # using a key,value parameter list. 
      def find(loc_regexp, &block)
        if block_given?
          self.nodes.inject({}) do |n, k,v|
            n[k] = v if block.call(k,v)
            n
          end
        else
          self.nodes.keys.find { |k| k =~ loc_regexp }
        end
      end
    end

    include PStoreMethods
    
    # The physical location of the node
    attr_reader :location
    
    def initialize(location)
      @location = location
      register_node
    end
    
    protected
      def register_node
        pstore_save(self)
      end
  end
end