require "yaml"

module StudyCards
  class RootDeckConfig
    DEFAULT_ID_SUFFIX = "-123"

    def self.load(path:)
      config = {}
      config_path = File.join(path, "config.yml")
      config = YAML.safe_load(File.read(config_path)) if File.exist?(config_path)

      self.new(config)
    end

    def initialize(config)
      @config = config
    end

    def id = @config.fetch("id")
    def name = @config.fetch("name")
    def review_reverse = @config.fetch("review_reverse")
  end
end
