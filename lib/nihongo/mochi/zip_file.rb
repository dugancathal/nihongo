require "zip"
require "tmpdir"

module Nihongo
  module Mochi
    class ZipFile
      def self.parse(path:)
        data = extract_mochi_content(path:)
        decks = TransitJson.arrayify(data["~:decks"]).map { Mochi::Deck.parse(_1) }
        self.new(decks:)
      end

      private_class_method def self.extract_mochi_content(path:)
        content = ""
        Dir.mktmpdir do |dir|
          Zip::File.open(path) do |zip|
            zip.extract("data.json", destination_directory: dir)
          end

          content = File.read(File.join(dir, "data.json"))
        end
        JSON.parse(content)
      end

      attr_reader :decks

      def initialize(decks: [])
        @decks = decks
      end

      def merge(markdown_decks)
        return self if markdown_decks.empty?

        updated = markdown_decks.map do |mddeck|
          associated_mochi_deck = decks.find { it.id == mddeck.id }

          next mddeck.to_mochi if associated_mochi_deck.nil?

          mochi_cards = associated_mochi_deck.cards
          associated_mochi_deck.with(
            **mddeck.as_mochi_attrs,
            cards: mddeck.cards.map do |mdcard|
              associated_mochi_card = mochi_cards.find { it.id == mdcard.id }

              next mdcard.to_mochi if associated_mochi_card.nil?
              associated_mochi_card.with(**mdcard.as_mochi_attrs)
            end
          )
        end

        self.class.new(decks: updated)
      end
    end
  end
end
