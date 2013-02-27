require 'slim'
require 'sinatra/base'
require 'sinatra/twitter-bootstrap'
require 'mongo'

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

  get '/' do
    slim :index
  end

  get '/apidesign' do
    slim :apidesign
  end

  get '/bible' do
    slim :bible
  end

  get '/api/v1/bible/:bookname/:chapter/:verse' do
    settings.mongo_db['bible'].find({bookname: params[:bookname], chapter: params[:chapter], verse: params[:verse]})
  end

  get '/quran' do
    slim :quran
  end

  get '/collections' do
    settings.mongo_db.collection_names
  end

end
