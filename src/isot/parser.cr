require "xml"
require "uri"

module Isot

  # = Isot::Parser
  #
  # Parses WSDL documents and remembers their important parts.
  class Parser

    XSD      = "http://www.w3.org/2001/XMLSchema"
    WSDL     = "http://schemas.xmlsoap.org/wsdl/"
    SOAP_1_1 = "http://schemas.xmlsoap.org/wsdl/soap/"
    SOAP_1_2 = "http://schemas.xmlsoap.org/wsdl/soap12/"

    # Returns the XML document.
    getter document : XML::Node

    # Returns the target namespace.
    getter namespace : String

    # Returns a map from namespace identifier to namespace URI.
    getter namespaces : Hash(String, String)

    # Returns the SOAP operations.
    getter operations : Hash(String, Hash(Symbol, String))

    # Returns a map from a type name to a Hash with type information.
    getter types

    # Returns a map of deferred type Proc objects.
    getter deferred_types

    # Returns the SOAP endpoint.
    getter endpoint : URI

    # Returns the SOAP Service Name
    getter service_name : String

    # Returns the elementFormDefault value.
    getter element_form_default : String

    def initialize(@document)
      @namespace = ""
      @namespaces = {} of String => String
      @operations = {} of String => Hash(Symbol, String)
      @endpoint = URI.new
      @service_name = ""
      @element_form_default = "unqualified"
    end

    def parse
      parse_namespaces
      parse_endpoint
      parse_service_name
      parse_messages
      parse_port_types
      parse_port_type_operations
      parse_operations
      parse_operations_parameters
      parse_types
      parse_deferred_types
    end

    def parse_namespaces

    end

    def parse_endpoint

    end

    def parse_url(url)

    end

    def parse_service_name

    end

    def parse_messages

    end

    def parse_port_types

    end

    def parse_port_type_operations

    end

    def parse_operations_parameters

    end

    def parse_operations

    end

    def parse_types

    end

    def process_type(namespace, type, name)

    end

    def parse_deferred_types

    end

    def input_for(operation)

    end

    def output_for(operation)

    end

    def input_output_for(operation, input_output)

    end

    def schemas

    end

    def service

    end

    def section(section_name)

    end

    def sections

    end
  end
end
