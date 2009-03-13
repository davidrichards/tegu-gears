require File.join(File.dirname(__FILE__), "/../spec_helper")

require File.dirname(__FILE__) + '/../../lib/examples/composition'
include Composition

describe Composition do

  it "should be able to compose blocks" do
    (emitter | doubler).resume.should eql(0)
    (emitter | doubler).resume.should eql(2)
    (emitter | doubler).resume.should eql(4)
  end
  
end
