module StudyCards
  class MarkdownDecks
    def self.load(data_dir: File.expand_path("../../data", __dir__), root_deck: "nihongo")
      decks_root = File.join(data_dir, root_deck)
      mdfiles = Dir[File.join(decks_root, "**/*.mochi.md")].filter_map do |path|
        MarkdownFile.parse_file(path:)
      rescue Exception => e
        StudyCards.logger.puts "Failed to parse file: #{path}"
        StudyCards.logger.puts e
        nil
      end

      decks_by_name = Hash.new { |h, k| h[k] = Deck.new(id: "#{root_deck}deck#{k.gsub('-','')}", name: k) }

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
