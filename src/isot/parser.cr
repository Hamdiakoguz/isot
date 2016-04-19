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
      debug("Initializing parser.")
      @namespace = ""
      @namespaces = {} of String => String
      @operations = {} of String => Hash(Symbol, String)
      @endpoint = URI.new
      @service_name = ""
      @element_form_default = "unqualified"

      @sections = {} of String => Array(XML::Node)
      @messages = {} of String => XML::Node
      @port_types = {} of String => XML::Node
      @port_type_operations = {} of String => Hash(String, XML::Node)
    end

    class Error < Exception
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
    rescue e
      debug("Parse error. #{e.inspect_with_backtrace}")
      raise Error.new "WSDL parse error.", e
    end

    def parse_namespaces
      debug("Parsing namespaces.")
      element_form_default = schemas.first?.try &.["elementFormDefault"]?
      @element_form_default = element_form_default.to_s if element_form_default
      debug("@element_form_default: #{@element_form_default}")

      namespace = root["targetNamespace"]
      @namespace = namespace.to_s if namespace
      debug("@namespace: #{@namespace}")

      @namespaces = {} of String => String
      root.namespaces.each do |key, value|
        @namespaces[key.sub("xmlns:", "")] = value.to_s
      end
    end

    def parse_endpoint
      if service_node = service
        endpoint = service_node.xpath_node(".//soap11:address/@location", namespaces: {"soap11": SOAP_1_1})
        endpoint ||= service_node.xpath_node(".//soap12:address/@location", namespaces: {"soap12": SOAP_1_2})
      end

      @endpoint = parse_url(endpoint.content) if endpoint
    end

    def parse_url(url)
      unescaped_url = URI.unescape(url.to_s)
      escaped_url   = URI.escape(unescaped_url)
      URI.parse(escaped_url)
    rescue URI::Error
      URI.new
    end

    def parse_service_name
      service_name = root["name"]?
      @service_name = service_name.to_s if service_name
    end

    def parse_nodes_with_name(root_node : XML::Node, name : String)
      hash = {} of String => XML::Node
      root_node.children.each do |node|
        if node.name == name
          hash[node["name"].not_nil!] = node
        end
      end
      hash
    end

    def parse_messages
      @messages = parse_nodes_with_name(root, "message")
    end

    def parse_port_types
      @port_types = parse_nodes_with_name(root, "portType")
    end

    def parse_port_type_operations
      @port_type_operations = {} of String => Hash(String, XML::Node)

      @port_types.each do |port_type_name, port_type|
        @port_type_operations[port_type_name] = parse_nodes_with_name(port_type, "operation")
      end
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
      types = section("types").try &.first?
      types ? types.children : [] of XML::Node
    end

    def service
      services = section("service")
      services.first? if services  # service nodes could be imported?
    end

    def section(section_name)
      sections[section_name]?
    end

    def sections
      return @sections if @sections.any?

      root.children.each do |node|
        (@sections[node.name] ||= [] of XML::Node) << node
      end

      @sections
    end

    def root
      document.root.not_nil!
    end

    private def debug(message)
      Isot.debug(message, "Isot::Parser")
    end
  end
end
