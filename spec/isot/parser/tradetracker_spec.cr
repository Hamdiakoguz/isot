require "../../spec_helper"

describe Isot::Parser do
  context "with: tradetracker.wsdl" do
    subject = fixture(:tradetracker).parse

    it "parses the operations" do
      subject.operations[:get_feeds][:input].should eq({"getFeeds" => {"affiliateSiteID"=>["xsd", "nonNegativeInteger"], "options"=>["tns", "FeedFilter"]}})
    end
  end
end
