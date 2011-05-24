require File.dirname(__FILE__) + "/../../app/domain/command"

describe Command do

  it "should execute the specified function on the first arg" do
    arg = "hello"
    command = Command.new(arg, lambda {|arg| arg + " world"})
    result = command.execute()
    result.should == "hello world"
    command.to_s.should == arg
  end

end