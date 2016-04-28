require "../../spec_helper"

describe Isot::Parser do
  context "with: tradetracker.wsdl" do
    subject = fixture(:tradetracker).parse

    it "parses the operations" do
      first, second = subject.operations["get_feeds"].inputs
      first.name.should eq("affiliateSiteID")
      first.type.should eq("xsd:nonNegativeInteger")
      second.name.should eq("options")
      second.type.should eq("tns:FeedFilter")
    end
  end
end
