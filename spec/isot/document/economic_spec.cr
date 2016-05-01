require "../../spec_helper"

describe Isot::Document do
  context "with: economic.wsdl" do
    document = Isot::Document.new fixture(:economic).read

    it "has an ok.read-time for huge wsdl files" do
      document.operations.size.should eq(1511)
    end
  end
end
