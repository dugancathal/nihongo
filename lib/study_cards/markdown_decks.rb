module StudyCards
  class MarkdownDecks

    def self.names(data_dir: StudyCards.default_data_dir)
      Dir[File.join(data_dir, "*")].map { |path| File.basename(path) }
    end

    def self.load_all(data_dir: StudyCards.default_data_dir)
      names(data_dir:).each_with_object({}) do |name, h|
        h[name] = load(data_dir: data_dir, root_deck: name)
      end
    end

    def self.load(data_dir: StudyCards.default_data_dir, root_deck: "nihongo")
      decks_root = data_dir + root_deck
      root_config = RootDeckConfig.load(path: decks_root)

      mdfiles = Dir[decks_root + "**/*.mochi.md"].filter_map do |path|
        MarkdownFile.parse_file(path:)
      rescue Exception => e
        StudyCards.logger.puts "Failed to parse file: #{path}"
        StudyCards.logger.puts e
        nil
      end

      root_deck = Deck.new(name: root_config.name, id: root_config.id)
      decks_by_name = Hash.new { |h, k| h[k] = Deck.new(id: "#{root_deck}deck#{k.gsub('-','')}", name: k) }

      files_by_deck = mdfiles.group_by(&:deck_name)
      files_by_deck.each do |name, files|
        files.each do |file|
          decks_by_name[name].add_cards(file.cards)
          root_deck.add_subdeck(decks_by_name[name])
        end
      end

      self.new(decks: [root_deck])
    end

    def initialize(decks: [])
      @decks = decks
    end

    def root_deck = @decks.first

    def map(&block)
      @decks.flat_map do |deck|
        [block.call(deck)] + deck.children.map { |child| block.call(child) }
      end
    end

    def empty? = @decks.empty?
  end
end
