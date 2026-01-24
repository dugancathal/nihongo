require "date"
require "time"
require "json"
require "securerandom"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem

module StudyCards
  def self.logger = @logger || $stderr
  def self.logger=(other)
    @logger = other
  end

  def self.gen_id = @id_generator ? @id_generator.call : SecureRandom.uuid_v7.gsub('-', '')
  def self.gen_id=(other)
    @id_generator = other
  end
end

loader.setup
