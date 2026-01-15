require "sinatra/base"
require "stringio"

require "nihongo"

module Nihongo
  class App < Sinatra::Base
    set :host_authorization, { permitted_hosts: [] }

    get '/' do
      erb :index
    end

    post '/sync' do
      content_type 'application/zip'

      file_field = params[:file]
      attachment file_field[:filename] + ".synced.mochi"

      stream do |out|
        Nihongo::Sync.stream(from: file_field[:tempfile], to: out)
      end
    end
  end
end
