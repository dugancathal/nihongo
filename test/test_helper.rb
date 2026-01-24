require "minitest/autorun"


$LOAD_PATH << File.expand_path("../lib", __dir__)
require "study_cards"

class NoopLogger
  def puts = nil
end

StudyCards.logger = NoopLogger.new
