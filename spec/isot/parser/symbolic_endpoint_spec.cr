require "../../spec_helper"

describe Isot::Parser do
  context "with: symbolic_endpoint.wsdl" do

    subject = fixture(:symbolic_endpoint).parse

    it "allows symbolic endpoints" do
      subject.endpoint.should be_nil
    end

    # it "should position base class attributes before subclass attributes in :order! array" do
    #   type = subject.types["ROPtsLiesListe"]
    #   type[:order!].should eq(["messages", "returncode", "listenteil"])
    # end

  end
end
