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

      def initialize(decks: [])
        @decks = decks
      end
    end
  end
end
