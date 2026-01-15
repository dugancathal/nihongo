module Nihongo
  module Sync
    ROOT_DECK = Nihongo::Mochi::Deck.new(
      id: "~:nihongodeck123",
      name: "Nihongo",
      review_reverse: true
    )

    def self.call(path:)
      app_data = Nihongo::Mochi::ZipFile.parse(path:)
      source_of_truth = Nihongo::MarkdownDecks.load
      app_data.merge(source_of_truth, root_deck: ROOT_DECK).dump_to(path: path + ".#{Time.now.to_i}.mochi")
    end

    def self.stream(from:, to:)
      app_data = Nihongo::Mochi::ZipFile.parse_stream(stream: from)
      source_of_truth = Nihongo::MarkdownDecks.load

      outstream = StringIO.new
      app_data.merge(source_of_truth, root_deck: ROOT_DECK).stream_to(to: outstream)

      outstream.rewind
      outstream.each { to << it }
    end

    def self.dump(to:)
      app_data = Nihongo::Mochi::ZipFile.new

      source_of_truth = Nihongo::MarkdownDecks.load
      app_data.merge(source_of_truth, root_deck: ROOT_DECK).dump_to(path: to)
    end
  end
end
