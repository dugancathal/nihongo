require "sinatra/base"
require "stringio"

require "study_cards"

module StudyCards
  class App < Sinatra::Base
    set :host_authorization, { permitted_hosts: [] }

    get '/' do
      @decks = StudyCards::MarkdownDecks.names
      erb :index
    end

    post '/sync' do
      root_deck = params.fetch(:root_deck, "nihongo")
      content_type 'application/zip'

      file_field = params[:file]
      attachment file_field[:filename] + ".synced.mochi"

      stream do |out|
        StudyCards::Sync.stream(root_deck:, from: file_field[:tempfile], to: out)
      end
    end
  end
end
