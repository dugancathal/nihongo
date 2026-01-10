module Nihongo
  module Sync
    def self.call(path:)
      app_data = Nihongo::Mochi::ZipFile.parse(path:)
      source_of_truth = Nihongo::MarkdownDecks.load
      app_data.merge(source_of_truth).dump_to(path: path + ".#{Time.now.to_i}.mochi")
    end

    def self.dump(to:)
      app_data = Nihongo::Mochi::ZipFile.new
      source_of_truth = Nihongo::MarkdownDecks.load
      app_data.merge(source_of_truth).dump_to(path: to)
    end
  end
end
