require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe Fibonacci do
  it "should calculate the fibonacci, up to n" do
    Fibonacci.call(3).should eql(2)
    Fibonacci.call(4).should eql(3)
    Fibonacci.call(5).should eql(5)
  end
end