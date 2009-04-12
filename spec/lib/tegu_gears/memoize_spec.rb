require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe Memoize do
  before(:all) do
    class A
      include Memoize
      
      def process(x)
        x**2
      end
    end
  end
  
  context "class methods" do
    it "should make instance available" do
      A.should be_respond_to(:instance)
    end
    
    it "should return an instance of the host (the class that includes Memoize)" do
      A.instance.should be_is_a(A)
    end
    
    it "should pass unknown calls to host instance" do
      @a = A.instance
      @a.should_receive(:blah).and_return(true)
      A.blah
    end
  end
  
  context "instance methods" do
    
    before(:each) do
      @a = A.new
    end
    
    it "should map call to function" do
      @a.should_receive(:function).and_return(true)
      @a.call(1)
    end
    
    it "should make memoize accessible" do
      @a.memoize = false
      @a.memoize.should eql(false)
      @a.memoize = true
      @a.memoize.should eql(true)
    end
    
    it "should default memoize to true" do
      @a.memoize.should eql(true)
    end
    
    it "should expect process to define the class' core function.  This is the only method that a host class needs to implement." do
      @a.should_receive(:process).and_return('found me')
      @a.call(:anything).should eql('found me')
    end
    
    it "should stuff a memoized value into cache" do
      @a.call(2)
      @a.cache[2].should eql(4)
    end
    
    it "should not refer to the cache when memoize is set to false" do
      @a.memoize = false
      @a.should_not_receive(:memoized)
      @a.should_not_receive(:cache)
      @a.call(2)
    end
    
    it "should be able to clear the cache" do
      @a.call(2)
      @a.flush
      @a.cache.should be_empty
    end
  end
  
  after(:all) do
    Object.send(:remove_const, :A)
  end
end
