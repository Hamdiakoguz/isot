require "logger"
require "./isot/*"

module Isot

  @@logger : Logger?
  @@logger = nil

  # Logger useful for debugging parse operations. Set to nil to turn off. default nil.
  def self.logger=(logger)
    @@logger = logger
  end

  def self.logger
    @@logger
  end

  # Output debug information to logger.
  def self.debug(message, progname = "Isot")
    @@logger.not_nil!.debug(message, progname) if @@logger
  end
end
