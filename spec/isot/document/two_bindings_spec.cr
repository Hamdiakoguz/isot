require "../../spec_helper"

describe Isot::Document do
  context "with: two_bindings.wsdl" do
    document = Isot::Document.new fixture(:two_bindings).read

    describe "#element_form_default" do
      it "returns element_form_default" { document.element_form_default == "unqualified" }
    end

    it "has 3 operations" do
      document.operations.size.should eq(3)
    end

    describe "#operations" do
      it "returns operations" do
        document.operations["post"].action.should eq("Post")
        document.operations["post"].inputs.first.name.should eq("Post")

        document.operations["post11only"].action.should eq("Post11only")
        document.operations["post11only"].inputs.first.name.should eq("Post11only")

        document.operations["post12only"].action.should eq("Post12only")
        document.operations["post12only"].inputs.first.name.should eq("Post12only")
      end
    end
  end
end
