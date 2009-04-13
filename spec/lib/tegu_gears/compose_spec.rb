require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe TeguGears, "compose" do
  before(:all) do
    class Square
      include TeguGears
      def process(n)
        n ** 2
      end
    end

    class SquareRoot
      include TeguGears
      def process(n)
        Math.sqrt(n)
      end
    end
  end
  
  it "should compose two functions manually" do
    square_root = SquareRoot.instance
    square = Square.instance
    (square_root | square).call(2).should be_close(2.0, 0.0001)
  end
  
  it "should be able to compose two functions from their host classes" do
    (SquareRoot | Square).call(2).should be_close(2.0, 0.0001)
  end
  
  it "should read the composition left to right" do
    plus_two = lambda{|x| x + 2}
    times_two = lambda{|x| x * 2}
    # IF this was right to left, it would be 10
    (plus_two | times_two).call(4).should eql(12)
    (times_two | plus_two).call(4).should eql(10)
  end
  
  context "from Object" do
    it "should have a version available for any lambda or method" do
      compose(2, SquareRoot, Square).should be_close(2.0, 0.0001)
    end
  
    it "should be able to take any number of compositions at once" do
      cube_root = lambda{|x| x ** (1/3.0)}
      half = lambda{|x| x / 2.0}
      twice = lambda{|x| x * 2.0}
      quadruple = lambda{|x| x * 4.0}
      compose(2, quadruple, twice, half, cube_root).should eql(2.0)
    end
    
    it "should read left to right" do
      plus_two = lambda{|x| x + 2}
      times_two = lambda{|x| x * 2}
      # IF this was right to left, it would be 10
      compose(4, plus_two, times_two).should eql(12)
      compose(4, times_two, plus_two).should eql(10)
    end
  end
  
  after(:all) do
    Object.send(:remove_const, :Square)
    Object.send(:remove_const, :SquareRoot)
  end
end