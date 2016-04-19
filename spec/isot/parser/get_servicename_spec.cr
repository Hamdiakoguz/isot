require "../../spec_helper"

describe Isot::Parser do
  context "with: geotrust.wsdl" do

    parser = fixture(:geotrust).parse

    it "returns the #service_name attribute" do
      parser.service_name.should eq("queryDefinitions")
    end

  end
end
