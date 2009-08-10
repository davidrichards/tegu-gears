require File.join(File.dirname(__FILE__), "/spec_helper")

describe "TeguGears" do
  it "should require rubygems" do
    defined?(Gem).should eql('constant')
  end
  
  it "should require the examples" do
    defined?(Fibonacci).should eql('constant')
  end
  
  it "should automatically include any sub-modules when included" do
    class A; include TeguGears end
    A.included_modules.should be_include(TeguGears::Memoize)
    Object.send(:remove_const, :A)
  end
  
  it "should use AMQP" do
    defined?(AMQP).should eql('constant')
  end
end
