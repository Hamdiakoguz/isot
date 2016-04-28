require "xml"
require "uri"
require "./core_ext/string"

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
    getter operations : Hash(String, Operation)

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
      @operations = {} of String => Operation
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
      debug("Parsing operations.")
      operations = document.xpath_nodes("wsdl:definitions/wsdl:binding/wsdl:operation", namespaces: {"wsdl": WSDL})
      operations.each do |operation|
        name = operation["name"].not_nil!
        snakecase_name = Isot::CoreExt::String.snakecase(name)

        # TODO: check for soap namespace?
        soap_operation = operation.children.find { |node| node.name == "operation" }
        soap_action = soap_operation.attributes["soapAction"]? if soap_operation

        if soap_action
          soap_action = soap_action.to_s
          action = soap_action && !soap_action.empty? ? soap_action.to_s : name

          # There should be a matching portType for each binding, so we will lookup the input from there.
          namespace_id, output = output_for(operation)
          namespace_id, input = input_for(operation)

          # Store namespace identifier so this operation can be mapped to the proper namespace.
          @operations[snakecase_name] = Operation.new(name, action, input, output, namespace_id)
        elsif !@operations[snakecase_name]?
          @operations[snakecase_name] = Operation.new(name, name, [Message.new(name)])
        end
      end
      debug("Operations: #{@operations.inspect}")
    end

    def input_for(operation)
      input_output_for(operation, "input")
    end

    def output_for(operation)
      input_output_for(operation, "output")
    end

    def input_output_for(operation, input_output)
      operation_name = operation["name"].not_nil!

      # Look up the input by walking up to portType, then up to the message.

      binding_type = operation.parent.not_nil!["type"].to_s.split(":").last
      if @port_type_operations[binding_type]?
        port_type_operation = @port_type_operations[binding_type][operation_name]?
      end

      port_type_input_output = port_type_operation &&
        port_type_operation.children.find { |node| node.name == input_output }

      # TODO: Stupid fix for missing support for imports.
      # Sometimes portTypes are actually included in a separate WSDL.
      if port_type_input_output
        if port_type_input_output["message"].to_s.includes? ":"
          port_message_ns_id, port_message_type = port_type_input_output["message"]?.to_s.split(":")
        else
          port_message_type = port_type_input_output["message"].to_s
        end

        message_ns_id = nil
        message_type = nil

        # When there is a parts attribute in soap:body element, we should use that value
        # to look up the message part from messages array.
        input_output_element = operation.children.find { |node| node.name == input_output }
        if input_output_element
          soap_body_element = input_output_element.children.find { |node| node.name == "body" }
          soap_body_parts = soap_body_element["parts"]? if soap_body_element
        end

        message = @messages[port_message_type]
        port_message_part = message.children.find do |node|
          soap_body_parts.nil? ? (node.name == "part") : ( node.name == "part" && node["name"] == soap_body_parts)
        end

        if port_message_part && port_message_part["element"]?
          port_message_part = port_message_part["element"]?.to_s
          if port_message_part.includes?(':')
            message_ns_id, message_type = port_message_part.split(':')
            return {message_ns_id, [Message.new(port_message_type, element: message_type)]}
          else
            message_type = port_message_part
            return {nil, [Message.new(port_message_type, element: message_type)]}
          end
        end

        # if multi part message, return messages
        part_messages = message.children.select { |node| node.name == "part" && node.attributes["type"]? }.size
        if part_messages > 0
          # part_messages_hash = {} of String => Hash(String, Array(String))
          # part_messages_hash[operation_name] = {} of String => Array(String)
          messages = [] of Message
          message.children.select { |node| node.name == "part" }.each do |node|
            part_message_name = node["name"].not_nil!
            part_message_type = node["type"].not_nil!
            messages << Message.new(part_message_name, type: part_message_type)
          end
          return {port_message_ns_id, messages}
        end

        {port_message_ns_id, [Message.new(operation_name)]}
      else
        {nil, [Message.new(operation_name)]}
      end
    end

    def parse_types

    end

    def process_type(namespace, type, name)

    end

    def parse_deferred_types

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

  struct Operation
    getter name : String
    getter action : String
    getter inputs : Array(Message)
    getter outputs : Array(Message)?
    getter namespace_identifier : String?

    def initialize(@name, @action, @inputs, @outputs = nil, @namespace_identifier = nil)
    end
  end

  # The WSDL message element defines an abstract message that can serve as the input or output of an operation.
  #
  # Messages consist of one or more part elements, where each part is associated with either
  # an element (when using document style) or
  # a type (when using RPC style).
  struct Message
    getter name : String
    getter type : String?
    getter element : String?

    def initialize(@name, @element = nil, @type = nil)
    end
  end
end
