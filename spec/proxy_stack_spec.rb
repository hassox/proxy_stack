require ::File.expand_path(::File.dirname(__FILE__) + '/spec_helper')

describe "proxy_stack" do
  def app
    proxy_stack.stackup
  end

  it "fails" do
    fail "hey buddy, you should probably rename this file and start specing for real"
  end
end
