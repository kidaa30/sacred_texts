require 'slim'
require 'sinatra/base'
require 'sinatra/twitter-bootstrap'
require 'mongo'
require 'json'

class App < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets

  configure do
    host = ENV['MONGO_HOST']
    port = ENV['MONGO_PORT']
    inst = ENV['MONGO_DB']
    user = ENV['MONGO_USER']
    pass = ENV['MONGO_PASS']

    db = Mongo::Connection.new(host, port).db(inst)
    db.authenticate(user, pass)
    set :mongo_db, db
  end

  # static pages
  get '/' do
    slim :index
  end

  get '/apidesign' do
    slim :apidesign
  end

  get '/bible' do
    slim :bible
  end

  get '/quran' do
    slim :quran
  end

  get '/collections' do
    settings.mongo_db.collection_names
  end

  # "simple" lookups
  get %r{/api/v1/bible/([\w]+)/([\d]+)/([\d]+)} do |book, chapter, verse|
    content_type :json
    verse = settings.mongo_db['bible'].find_one(
      {
        bookname: book,
        chapter: chapter.to_i,
        verse: verse.to_i
      },
      {
        fields: {_id: 0}
      }
    )

    if verse.nil?
      status 404
      {"error" => "No results found."}.to_json
    else
      verse.to_json
    end
  end

  # "complex" lookups
  get '/api/v1/bible/' do
    content_type :json
    passage = params['passage']
    search = params['search']
    type = params['type']

    # cannot be both a passage and a lookup
    if (!passage.nil? && !search.nil?)
      status 400
      {"error" => "Only one of the parameters 'passage' and 'search' can be specified."}.to_json
    elsif (passage.nil? && !search.nil?)
      # keyword search
      verses = settings.mongo_db['bible'].find(
        {
          text: /#{search}/
        },
        {
          fields: {_id: 0}
        }
      )
      {
        "results" => verses.to_a
      }.to_json
    else
      # passage
      {"passage" => "todo"}.to_json
    end
  end

end
