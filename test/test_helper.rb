require "minitest"


$LOAD_PATH << File.expand_path("../lib", __dir__)
require "nihongo"

class NoopLogger
  def puts = nil
end

Nihongo.logger = NoopLogger.new
