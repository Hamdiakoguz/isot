require "spec"
require "../src/isot"
require "./support/fixture"
require "./support/uri"

logger = Logger.new(File.new("spec.log", "a"))
logger.level = Logger::DEBUG
Isot.logger = logger
