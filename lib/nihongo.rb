require "date"
require "time"
require "json"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem

module Nihongo
  def self.logger = @logger || $stderr
  def self.logger=(other)
    @logger = other
  end
end

loader.setup
