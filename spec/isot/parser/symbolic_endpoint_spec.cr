require "../../spec_helper"

describe Isot::Parser do
  context "with: symbolic_endpoint.wsdl" do

    subject = fixture(:symbolic_endpoint).parse

    it "allows symbolic endpoints" do
      subject.endpoint.host.should eq(nil)
    end

    it "should position base class attributes before subclass attributes in elements array" do
      type = subject.types["ROPtsLiesListe"]
      type.elements.map(&.name).should eq(["messages", "returncode", "listenteil"])
    end

  end
end
