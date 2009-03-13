require File.dirname(__FILE__) + '/../spec_helper'

describe Shared do
  it "should have a pool" do
    Shared.should be_respond_to(:pool)
  end
  
  # Need to think about this and the configuration.
  
  it "should have a spawn" do
    Shared.should be_respond_to(:spawn)
  end
  
  it "should spawn a new process from a block" do
    Shared.spawn{1+1}
  end
end
