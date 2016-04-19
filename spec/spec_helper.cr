require "spec"
require "../src/isot"
require "./support/fixture"

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG
Isot.logger = logger

