require "http"

module Isot
  # = Isot::Resolver
  #
  # Resolves local and remote WSDL documents.
  class Resolver
    class HTTPError < Exception
      getter response : HTTP::Client::Response?

      def initialize(message, @response = nil)
        super(message)
      end
    end

    URL = /^http[s]?:/
    XML = /^</

    def self.resolve(document)
      raise ArgumentError.new("Unable to resolve: #{document.inspect}") unless document
      Isot.debug("Resolving document.", "Isot::Resolver")

      case document
      when URL then load_from_remote(document)
      when XML then document
      else          load_from_disc(document)
      end
    end

    private def self.load_from_remote(document)
      response = HTTP::Client.get(document)
      Isot.debug("HTTP response: #{response.inspect}", "Isot::Resolver")

      raise HTTPError.new("Error: #{response.status_code} for url #{document}", response) unless response.success?

      response.body
    end

    private def self.load_from_disc(document)
      Isot.debug("Loading document from disc: #{document.inspect}", "Isot::Resolver")
      File.read(document)
    end
  end
end
