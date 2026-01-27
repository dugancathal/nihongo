require "zip"
require "yaml"
require "tmpdir"

module StudyCards
  module Mochi
    class ZipFile
      def self.parse(path:)
        data = extract_mochi_content(from: path, zipfile_extraction_message: :open)
        decks = TransitJson.arrayify(data["~:decks"]).map { Mochi::Deck.parse(_1) }
        self.new(decks:)
      end

      def self.parse_stream(stream:)
        data = extract_mochi_content(from: stream, zipfile_extraction_message: :open_buffer)
        decks = TransitJson.arrayify(data["~:decks"]).map { Mochi::Deck.parse(_1) }
        self.new(decks:)
      end

      private_class_method def self.extract_mochi_content(from:, zipfile_extraction_message:)
        content = Dir.mktmpdir do |dir|
          Zip::File.public_send(zipfile_extraction_message, from) do |zip|
            zip.extract("data.json", destination_directory: dir)
          end

          File.read(File.join(dir, "data.json"))
        end
        JSON.parse(content)
      end

      attr_reader :decks

      def initialize(decks: [])
        @decks = decks
      end

      def merge(markdown_decks, root_deck: nil)
        return self if markdown_decks.empty?

        updated = markdown_decks.map do |mddeck|
          associated_mochi_deck = decks.find { it.id == TransitJson.keywordify(mddeck.id) }

          associated_mochi_deck ||= mddeck.to_mochi

          mochi_cards = associated_mochi_deck.cards
          associated_mochi_deck.with(
            **mddeck.as_mochi_attrs,
            parent_id: root_deck ? root_deck.id : associated_mochi_deck.parent_id,
            cards: mddeck.cards.map do |mdcard|
              associated_mochi_card = mochi_cards.find { it.id == TransitJson.keywordify(mdcard.id) }

              associated_mochi_card ||= mdcard.to_mochi
              associated_mochi_card.with(**mdcard.as_mochi_attrs)
            end
          )
        end

        self.class.new(decks: [root_deck&.to_mochi, *updated].compact)
      end

      def dump_to(path:)
        write_zip_of_decks(to: path, decks:)

        decks.each do |deck|
          write_zip_of_decks(to: path + ".#{deck.name}.mochi", decks: [deck])
        end
      end

      def stream_to(to:)
        Zip::OutputStream.write_buffer(to) do |zip|
          write_decks_to_zip(zip:, decks:)
        end
      end

      def dump_markdown_to(path:, name:)
        path = Pathname(path)
        deck_dir = path + name
        deck_dir.mkdir

        decks.each do |mochi_deck|
          markdown_deck = StudyCards::Deck.new(name: mochi_deck.name, id: mochi_deck.id, cards: [])
          cards = mochi_deck.cards.map { |card| StudyCards::Card.from_mochi(card:) }
          markdown_deck.add_cards(*cards)

          (deck_dir + "#{mochi_deck.name}.mochi.md").write(markdown_deck.to_markdown)
        end

        (deck_dir + "config.yml").write(YAML.dump("id" => name, "name" => name))
      end

      private

      def write_zip_of_decks(to:, decks:)
        Zip::OutputStream.open(to) do |zip|
          write_decks_to_zip(zip:, decks:)
        end
      end

      def write_decks_to_zip(zip:, decks:)
        out_data = {
          "~:version": 2,
          "~:decks": decks.map(&:as_transit_json)
        }

        zip.put_next_entry("data.json")
        zip << JSON.dump(out_data)
      end
    end
  end
end
