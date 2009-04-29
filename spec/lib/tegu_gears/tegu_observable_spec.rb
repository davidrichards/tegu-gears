require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe TeguObservable do
  
  before(:all) do
    class A
      include TeguObservable
      def value; 1 end
    end
  end
  
  after(:all) do
    Object.send(:remove_const, :A)
  end
  
  before do
    @a = A.new
    @b = mock('Some Process')
  end
  
  it "should have a hash of observers setup" do
    @a.should be_respond_to(:observers)
    @a.observers.should be_is_a(Hash)
  end
  
  context "add_observer" do
    it "should be able to use a block" do
      @a.observers.size.should eql(0)
      @a.add_observer {|val| val + 1}
      @a.observers.size.should eql(1)
    end
    
    it "should use a UUID for a key when a block is passed" do
      @a.add_observer {|val| val + 1}
      @a.observers.keys.first.should match(/[\d|\w]{8}-[\d|\w]{4}-[\d|\w]{4}-[\d|\w]{4}-[\d|\w]{12}/)
    end
    
    it "should be able to use another object" do
      @a.add_observer(@b)
      @a.observers[@b].should eql(@b)
      @a.delete_observer(@b)
    end
    
    it "should require an object or block" do
      lambda{@a.add_observer}.should raise_error(ArgumentError, 
        "Must provide a block or an object to receive messages.")
    end
    
  end
  
  it "should be able to delete an observer" do
    @a.observers.should be_empty
    @a.add_observer(@b)
    @a.delete_observer(@b)
    @a.observers.should be_empty
  end
  
  it "should have a list of anonymous observers" do
    @a.add_observer { |x| x + 1 }
    @a.anonymous_observers.size.should eql(1)
    @a.anonymous_observers.first.call(1).should eql(2)
  end
  
  context "notify_observers" do
    
    before do
      @a.add_observer(@b)
      @b.stub!(:update).and_return(true)
    end
    
    it "should tell the world of updates" do
      @b.should_receive(:update).and_return(true)
      @a.notify_observers
    end
    
    it "should call any procs given" do
      @find_me = 0
      @a.add_observer {|x| @find_me = x.value + 1}
      @a.notify_observers
      @find_me.should eql(2)
    end
  end
end
