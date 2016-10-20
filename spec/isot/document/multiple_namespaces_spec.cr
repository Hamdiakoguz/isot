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

    describe "#type_namespaces" do
      it "returns type namespaces" do
        type_namespaces = document.type_namespaces
        type_namespaces.should eq([
          Isot::Document::TypeNamespace.new("Save", "http://example.com/actions"),
          Isot::Document::TypeNamespace.new("Save", "http://example.com/actions", "article"),
          Isot::Document::TypeNamespace.new("Article", "http://example.com/article"),
          Isot::Document::TypeNamespace.new("Article", "http://example.com/article", "Author"),
          Isot::Document::TypeNamespace.new("Article", "http://example.com/article", "Title")
        ])
      end
    end

    describe "#type_definitions" do
      it "returns type definations" do
        type_definitions = document.type_definitions
        type_definitions.should eq([
          Isot::Document::TypeDefinition.new("Save", "article", "Article"),
        ])
      end
    end
  end
end
