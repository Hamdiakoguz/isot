require "../../spec_helper"

describe Isot::Document do
  context "with: multiple_namespaces.wsdl" do
    document = Isot::Document.new fixture(:multiple_namespaces).read

    describe "#namespace" do
      it "returns namespace" { document.namespace.should eq "http://example.com/actions" }
    end

    describe "#endpoint" do
      it "returns endpoint" { should_be_same_uri(document.endpoint, URI.parse("http://example.com:1234/soap")) }
    end

    describe "#element_form_default" do
      it "returns element_form_default" { document.element_form_default.should eq "qualified" }
    end

    it "has 1 operation" do
      document.operations.size.should eq(1)
    end

    describe "#operations" do
      it "returns operations" do
        document.operations.first_key.should eq("save")
        operation = document.operations.first_value
        operation.inputs.first.name.should eq("SaveSoapIn")
        operation.inputs.first.element.not_nil!.should eq("Save")
        operation.outputs.not_nil!.first.name.should eq("SaveSoapOut")
        operation.outputs.not_nil!.first.element.not_nil!.should eq("SaveResponse")
        operation.action.should eq("http://example.com/actions.Save")
        operation.namespace_identifier.should eq("actions")
        operation.parameters.first.name.should eq("article")
        operation.parameters.first.type.should eq("Article")
      end
    end

    # describe "#type_namespaces" do
    #   subject { super().type_namespaces }
    #   it do
    #     should =~ [
    #       [["Save"], "http://example.com/actions"],
    #       [["Save", "article"], "http://example.com/actions"],
    #       [["Article"], "http://example.com/article"],
    #       [["Article", "Author"], "http://example.com/article"],
    #       [["Article", "Title"], "http://example.com/article"]
    #     ]
    #   end
    # end

    # describe "#type_definitions" do
    #   subject { super().type_definitions }
    #   it do
    #     should =~ [ [["Save", "article"], "Article"] ]
    #   end
    # end

  end
end
