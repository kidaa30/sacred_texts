require 'slim'
require 'sinatra/base'
require 'sinatra/twitter-bootstrap'

class App < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets

  get '/' do
    slim :index
  end

  get '/apidesign' do
    slim :apidesign
  end

  get '/bible' do
    slim :bible
  end

  get '/api/bible/:query' do
    "bible, #{params[:query]}"
  end

  get '/quran' do
    slim :quran
  end

  get '/api/quran/:query' do
    "quran, #{params[:query]}"
  end

end
