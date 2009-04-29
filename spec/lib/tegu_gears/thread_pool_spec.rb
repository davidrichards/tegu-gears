require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe ThreadPool do
  
  it "should make thread available" do
    defined?(Thread).should eql('constant')
  end
  
  it "should make mutex available" do
    defined?(Mutex).should eql('constant')
  end
  
  context ThreadPool::Worker do
    before do
      @worker = ThreadPool::Worker.new
    end
    
    it "should be able to get and set a block" do
      b = lambda{1 + 1}
      @worker.set_block(b)
      @worker.get_block.should eql(b)
    end
    
    it "should be able to reset a block" do
      b = lambda{1 + 1}
      @worker.set_block(b)
      @worker.get_block.should eql(b)
      @worker.reset_block
      @worker.get_block.should be_nil
    end
    
    it "should know if it's busy" do
      b = lambda{1 + 1}
      @worker.set_block(b)
      @worker.busy?.should be_true
      @worker.reset_block
      @worker.busy?.should be_false
    end
    
    it "should raise an error if attempting to set more than one block on a thread" do
      b = lambda{1 + 1}
      @worker.set_block(b)
      lambda{@worker.set_block(b)}.should raise_error(RuntimeError, "Thread already busy.")
    end
  end
  
  context "instance methods" do
    before do
      @tp = ThreadPool.new
      @mutex = @tp.instance_variable_get(:@mutex)
    end
    
    it "should have a max size" do
      @tp.should be_respond_to(:max_size)
    end
    
    it "should default to a maximum of 10 threads" do
      @tp.max_size.should eql(10)
    end
    
    it "should be able to set a different thread pool max size" do
      @tp = ThreadPool.new(20)
      @tp.max_size.should eql(20)
    end
    
    it "should have a workers array" do
      @tp.should be_respond_to(:workers)
      @tp.workers.should be_is_a(Array)
    end
    
    it "should default to an empty list of workers" do
      @tp.workers.should eql([])
    end
    
    it "should have a safe lookup on size" do
      @tp.should be_respond_to(:size)
      @mutex.should_receive(:synchronize).and_return(0)
      @tp.size.should eql(0)
    end
    
    it "should have a safe lookup on busy, meaning if any thread is running" do
      @mutex.should_receive(:synchronize).and_return(false)
      @tp.busy?.should be_false
    end
    
    it "should use busy? to block while anything is busy" do
      @tp.should_receive(:busy?).and_return(false)
      @tp.join
    end
    
    it "should have an alias, ensure_complete, for join" do
      @tp.should_receive(:busy?).and_return(false)
      @tp.ensure_complete
    end
  end
  
end
