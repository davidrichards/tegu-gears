require File.dirname(__FILE__) + '/spec_helper'

describe "TeguGears" do
  it "should require rubygems" do
    defined?(Gem).should eql('constant')
  end
  
  it "should require neverblock" do
    defined?(NeverBlock).should eql('constant')
  end
  
  it "should require starling" do
    defined?(Starling).should eql('constant')
  end
end
