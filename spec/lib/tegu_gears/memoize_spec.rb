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
    
    # The issue is dealing with modules instead of true class variables.  I'm
    # affecting other classes with this. 
    # 
    # The solution is to create a configuration setup like with GritGateway on Object:
    # class A
    #   tegu_gears do |tg|
    #     tg.nix_memos
    #   end
    # end
    # 
    # Make both approaches available (include TeguGears)
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # it "should be able to nix all memoization" do
    #   A.should be_respond_to(:nix_memos)
    #   A.nix_memos
    #   A.memoize.should be_false
    # end
    # 
    # it "should be able to allow memoization" do
    #   A.should be_respond_to(:allow_memos)
    #   A.allow_memos
    #   A.memoize.should be_true
    # end
    # 
    # context "manage memoize" do
    #   before(:all) do
    #     class B
    #       include Memoize
    #       nix_memos
    #     end
    #   end
    #   
    #   after(:all) do
    #     Object.send(:remove_const, :B)
    #   end
    #   
    #   it "should default to the class setting" do
    #     b = B.new
    #     require 'rubygems'
    #     require 'ruby-debug'
    #     debugger
    #     b.memoize.should be_false
    #     B.memoize.should be_false
    #   end
    #   
    # end
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
    
    it "should not refer to the cache when memoize is set to false" do
      @a.memoize = false
      MemoRepository.should_not_receive(:for)
      @a.call(2)
    end
    
    it "should be able to clear the cache" do
      @a.call(2)
      @a.flush
      MemoRepository.for(@a).should be_empty
    end
    
    it "should use the MemoRepository" do
      MemoRepository.flush_for(A)
      MemoRepository.for(@a)[2].should be_nil
      @a.call(2)
      MemoRepository.for(@a)[2].should eql(4)
    end
  end

  after(:all) do
    Object.send(:remove_const, :A)
  end
end

