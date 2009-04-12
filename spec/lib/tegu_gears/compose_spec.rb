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
    (square_root | square).call(2).should eql(2.0)
  end
  
  it "should be able to compose two functions from their host classes" do
    (SquareRoot | Square).call(2).should eql(2.0)
  end
  
  context "from Object" do
    it "should have a version available for any lambda or method" do
      compose(SquareRoot, Square, 2).should eql(2.0)
    end
  
    it "should be able to take any number of compositions at once" do
      cube_root = lambda{|x| x ** (1/3.0)}
      half = lambda{|x| x / 2.0}
      twice = lambda{|x| x * 2.0}
      quadruple = lambda{|x| x * 4.0}
      compose(cube_root, half, twice, quadruple, 2).should eql(2.0)
    end
  end
  
  after(:all) do
    Object.send(:remove_const, :Square)
    Object.send(:remove_const, :SquareRoot)
  end
end