module Nihongo
  class MarkdownFile
    Card = Data.define(:front, :back)

    FILE_EXTENSION = ".mochi.md"
    CARD_BOUNDARY = /-------\n?\s*/m
    CARD_SIDE_BOUNDARY = /---\n\s*/m

    def self.parse_file(path:)
      filename = File.basename(path, FILE_EXTENSION)
      self.parse(content: File.read(path), filename:)
    end

    def self.parse(filename:, content:)
      raw_cards = content.strip.split(CARD_BOUNDARY).map(&:strip)
      raw_front_backs = raw_cards.map { it.split(CARD_SIDE_BOUNDARY).map(&:strip) }
      cards = raw_front_backs.map { |front, back| Card[front:, back:] }
      self.new(filename:, cards:)
    end

    attr_reader :cards, :filename

    def initialize(filename:, cards: [])
      @filename = filename
      @cards = cards
    end

    def deck_name
      filename.sub(/-\d+$/, "")
    end
  end
end
