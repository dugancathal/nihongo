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

  def self.default_data_dir = @default_data_dir || Pathname(File.expand_path("../data", __dir__))
  def self.default_data_dir=(other)
    @default_data_dir = Pathname(other)
  end

  def self.with_default_data_dir(other)
    old_default_data_dir, self.default_data_dir = self.default_data_dir, other
    yield
  ensure
    self.default_data_dir = old_default_data_dir
  end
end

loader.setup
