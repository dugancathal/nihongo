module Nihongo
  class MarkdownDecks
    def self.load(data_dir: File.expand_path("../../data", __dir__))
      mdfiles = Dir[data_dir + "**/*.mochi.md"].filter_map do |path|
        MarkdownFile.parse_file(path:)
      rescue Exception => e
        Nihongo.logger.puts "Failed to parse file: #{path}"
        Nihongo.logger.puts e
        nil
      end

      decks_by_name = Hash.new { |h, k| h[k] = Deck.new(id: "nihongodeck#{k.gsub('-','')}", name: k) }

      files_by_deck = mdfiles.group_by(&:deck_name)
      files_by_deck.each do |name, files|
        files.each do |file|
          decks_by_name[name].add_cards(file.cards)
        end
      end

      self.new(decks: decks_by_name.values)
    end

    def initialize(decks: [])
      @decks = decks
    end

    def map(&block) = @decks.map(&block)
    def empty? = @decks.empty?
  end
end

