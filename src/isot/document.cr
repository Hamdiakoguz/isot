require "xml"
require "./resolver"
require "./parser"

module Isot
  # = Isot::Document
  #
  # Represents a WSDL document.
  class Document
    ELEMENT_FORM_DEFAULTS = ["unqualified", "qualified"]

    # Returns WSDL document. Can be a file path, uri or xml content.
    getter document : String

    # Returns a map of SOAP operations.
    getter operations : Hash(String, Isot::Operation)

    # Returns the value of elementFormDefault.
    getter element_form_default : String

    # Returns the SOAP endpoint.
    getter endpoint : URI

    # Returns the target namespace.
    getter namespace : String

    # Returns the service name.
    getter service_name : String

    @xml : String?
    @parser : Parser?

    # Accepts a WSDL *document* to parse. *document* can be a file path, uri or xml content.
    def initialize(@document, endpoint = nil, namespace = nil, service_name = nil, element_form_default = nil)
      @soap_operations = [] of String

      parse

      @endpoint = endpoint || parser.endpoint
      @namespace = namespace || parser.namespace
      @service_name = service_name || parser.service_name

      if element_form_default
        validate_element_form_default!(element_form_default)
        @element_form_default = element_form_default
      else
        @element_form_default = parser.element_form_default
      end

      @operations = parser.operations
    end

    # Validates if a given +value+ is a valid elementFormDefault value.
    # Raises an +ArgumentError+ if the value is not valid.
    private def validate_element_form_default!(value)
      return if ELEMENT_FORM_DEFAULTS.includes?(value)

      raise ArgumentError, "Invalid value for elementFormDefault: #{value}\n" +
        "Must be one of: #{ELEMENT_FORM_DEFAULTS.inspect}"
    end

    # Returns a list of available SOAP actions.
    def soap_actions
      operations.keys
    end

    # Returns the SOAP action for a given +key+.
    def soap_action(key)
      operations[key].action if operations[key]?
    end

    # Returns the SOAP input for a given +key+.
    def soap_input(key)
      operations[key].inputs if operations[key]?
    end

    # Returns a list of parameter names for a given +key+
    def soap_action_parameters(key)
      params = operation_input_parameters(key)
      params.keys if params
    end

    # Returns a list of input parameters for a given +key+.
    def operation_input_parameters(key)
      parser.operations[key].parameters if operations[key]
    end

    def type_namespaces
    end

    def type_definitions
    end

    # Returns whether the given *namespace* was defined manually.
    def user_defined(namespace)
      uri = parser.namespaces[namespace]
      !(uri =~ %r{^http://schemas.xmlsoap.org} || uri =~ %r{^http://www.w3.org})
    end

    # Returns the raw WSDL document.
    # Can be used as a hook to extend the library.
    def xml
      @xml ||= Resolver.resolve(document)
    end

    # Parses the WSDL document and returns the `Isot::Parser`.
    def parser
      @parser ||= parse
    end

    # Parses the WSDL document and returns `Isot::Parser`.
    private def parse
      parser = Parser.new(XML.parse(xml))
      parser.parse
      parser
    end

    private def element_keys(info)
      info.keys - [:namespace, :order!, :base_type]
    end
  end
end
