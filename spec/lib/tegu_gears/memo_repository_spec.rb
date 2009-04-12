require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe MemoRepository do
  it "should default to a hash" do
    @mr = MemoRepository.new
    @mr.store.should be_is_a(Hash)
  end
  
  it "should pass unknown calls to the store" do
    @mr = MemoRepository.new
    @mr.store.should_receive(:blah).and_return(true)
    @mr.blah
  end
  
  it "should be able to take a different kind of repository" do
    @mr = MemoRepository.new([])
    @mr.store.should be_is_a(Array)
  end
  
  it "should provide a quasi-singleton" do
    MemoRepository.instance.should be_is_a(MemoRepository)
  end
  
  it "should set the REPOSITORY_CLASS to a Hash" do
    REPOSITORY_CLASS.should eql(Hash)
  end
  
  it "should construct REPOSITORY_CLASS for the singleton" do
    REPOSITORY_CLASS.should_receive(:new).and_return(Hash.new)
    MemoRepository.instance
  end
  
  it "should pass unknown class calls down to the instance" do
    MemoRepository.instance.should_receive(:weird).and_return(true)
    MemoRepository.weird
  end
  
  context "scoped access" do
    before(:all) do
      class A
        include TeguGears
        def process(n)
          n + 1
        end
      end
    end
  
    it "should offer a set interface, that passes a scoped memo into the repository" do
      MemoRepository.set(A, 1, 2)
      MemoRepository.store.keys.should be_include(A)
    end
  
    context "for" do
      it "should offer a default empty hash" do
        MemoRepository.instance.for(:non_existent).should be_is_a(Hash)
        MemoRepository.instance.for(:non_existent).should be_empty
      end
      
      it "should offer whatever cache is available" do
        MemoRepository.set(A, 1, 2)
        @a_repo = MemoRepository.for(A)
        @a_repo.keys.should eql([1])
        @a_repo.values.should eql([2])
      end
      
      it "should take an optional second parameter, which return the specific value that has been cached." do
        MemoRepository.set(A, 1, 3)
        MemoRepository.for(A, 1).should eql(3)
        MemoRepository.flush_for(A)
      end
    end
    
    it "should be able to flush a single scope" do
      MemoRepository.for(A).should_not be_empty
      MemoRepository.flush_for(A)
      MemoRepository.for(A).should be_empty
    end
    
    after(:all) do
      Object.send(:remove_const, :A)
    end
  end
end