require "../../spec_helper"

describe Isot::Document do
  context "with: geotrust.wsdl" do
    document = Isot::Document.new fixture(:geotrust).read

    describe "#namespace" do
      it "returns namespace" { document.namespace.should eq "http://api.geotrust.com/webtrust/query" }
    end

    describe "#endpoint" do
      it "returns endpoint" { should_be_same_uri(document.endpoint, URI.parse("https://test-api.geotrust.com:443/webtrust/query.jws")) }
    end

    describe "#element_form_default" do
      it "returns element_form_default" { document.element_form_default.should eq "qualified" }
    end

    it "has 2 operations" do
      document.operations.size.should eq(2)
    end

    describe "#operations" do
      it "return operations" do
        document.operations["get_quick_approver_list"].name.should eq("GetQuickApproverList")
        document.operations["get_quick_approver_list"].action.should eq("GetQuickApproverList")
        document.operations["get_quick_approver_list"].parameters.first.name.should eq("Request")
        document.operations["get_quick_approver_list"].parameters.first.type.should eq("GetQuickApproverListInput")

        document.operations["hello"].name.should eq("hello")
        document.operations["hello"].action.should eq("hello")
        document.operations["hello"].parameters.first.name.should eq("Input")
        document.operations["hello"].parameters.first.type.should eq("string")
      end
    end

  end
end
