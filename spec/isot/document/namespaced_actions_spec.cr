require "../../spec_helper"

describe Isot::Document do
  context "with: namespaced_actions.wsdl" do
    document = Isot::Document.new fixture(:namespaced_actions).read

    describe "#namespace" do
      it "returns namespace" { document.namespace.should eq "http://api.example.com/api/" }
    end

    describe "#endpoint" do
      it "returns endpoint" { should_be_same_uri(document.endpoint, URI.parse("https://api.example.com/api/api.asmx")) }
    end

    describe "#element_form_default" do
      it "returns element_form_default" { document.element_form_default.should eq "qualified" }
    end

    it "has 3 operations" do
      document.operations.size.should eq(3)
    end

    describe "#operations" do
      it "returns operations" do
        document.operations["delete_client"].inputs.first.name.should eq("Client.DeleteSoapIn")
        document.operations["delete_client"].inputs.first.element.not_nil!.should eq("Client.Delete")
        document.operations["delete_client"].outputs.not_nil!.first.name.should eq("Client.DeleteSoapOut")
        document.operations["delete_client"].outputs.not_nil!.first.element.not_nil!.should eq("Client.DeleteResponse")
        document.operations["delete_client"].action.should eq("http://api.example.com/api/Client.Delete")
        document.operations["delete_client"].namespace_identifier.should eq("tns")

        document.operations["get_clients"].inputs.first.name.should eq("User.GetClientsSoapIn")
        document.operations["get_clients"].inputs.first.element.not_nil!.should eq("User.GetClients")
        document.operations["get_clients"].outputs.not_nil!.first.name.should eq("User.GetClientsSoapOut")
        document.operations["get_clients"].outputs.not_nil!.first.element.not_nil!.should eq("User.GetClientsResponse")
        document.operations["get_clients"].action.should eq("http://api.example.com/api/User.GetClients")
        document.operations["get_clients"].namespace_identifier.should eq("tns")

        document.operations["get_api_key"].inputs.first.name.should eq("User.GetApiKeySoapIn")
        document.operations["get_api_key"].inputs.first.element.not_nil!.should eq("User.GetApiKey")
        document.operations["get_api_key"].outputs.not_nil!.first.name.should eq("User.GetApiKeySoapOut")
        document.operations["get_api_key"].outputs.not_nil!.first.element.not_nil!.should eq("User.GetApiKeyResponse")
        document.operations["get_api_key"].action.should eq("http://api.example.com/api/User.GetApiKey")
        document.operations["get_api_key"].namespace_identifier.should eq("tns")
      end
    end
  end
end
