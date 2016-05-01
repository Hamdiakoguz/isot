require "../../spec_helper"

describe Isot::Document do
  context "with: no_namespace.wsdl" do
    document = Isot::Document.new fixture(:no_namespace).read

    describe "#namespace" do
      it "returns namespace" { document.namespace.should eq("urn:ActionWebService") }
    end

    describe "#endpoint" do
      it "returns endpoint" { should_be_same_uri(document.endpoint, URI.parse("http://example.com/api/api")) }
    end

    describe "#element_form_default" do
      it "returns element_form_default" { document.element_form_default.should eq("unqualified") }
    end

    it "has 3 operations" do
      document.operations.size.should eq(3)
    end

    # describe "#operations" do
    #   it do
    #     should include(
    #       { :get_user_login_by_id => { :input => { "GetUserLoginById" => { "api_key" => ["xsd", "string"], "id" => ["xsd", "int"] }}, :output=>{"GetUserLoginById"=>{"return"=>["xsd", "string"]}}, :action => "/api/api/GetUserLoginById", :namespace_identifier => "typens" } },
    #       { :get_all_contacts => { :input => {"GetAllContacts" => { "api_key" => ["xsd", "string"], "login"=>["xsd", "string"] }}, :output=>{"GetAllContacts"=>{"return"=>["typens", "McContactArray"]}}, :action => "/api/api/GetAllContacts", :namespace_identifier => "typens" } },
    #       { :search_user => { :input => { "SearchUser" => { "api_key" => ["xsd", "string"], "phrase"=>["xsd", "string"], "page"=>["xsd", "string"], "per_page"=>["xsd", "string"] }}, :output=>{"SearchUser"=>{"return"=>["typens", "MpUserArray"]}}, :action => "/api/api/SearchUser", :namespace_identifier => nil } }
    #     )
    #   end
    # end

  end
end
