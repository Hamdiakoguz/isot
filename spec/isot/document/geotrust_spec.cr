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

    # describe "#operations" do
    #   subject { super().operations }
    #   it do
    #     should include(
    #       { :get_quick_approver_list => { :input => "GetQuickApproverList", :action => "GetQuickApproverList", :parameters=>{:Request=>{:name=>"Request", :type=>"GetQuickApproverListInput"}}}},
    #       { :hello => { :input => "hello", :action => "hello", :parameters=>{:Input=>{:name=>"Input", :type=>"string"}} } }
    #       )
    #   end
    # end

  end
end
