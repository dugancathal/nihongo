module Nihongo
  module Sync
    def self.call(path:)
      app_data = Nihongo::Mochi::Zipfile.parse(path:)
      source_of_truth = Nihongo::MarkdownCards.load
      app_data.merge(source_of_truth).dump_to(path: path + ".#{Time.now.to_i}.mochi")
    end
  end
end
