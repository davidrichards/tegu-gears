require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe Factorial do
  it "should be able to return the factorial of a number" do
    Factorial.call(3).should eql(6)
    Factorial.call(6).should eql(720)
  end
end