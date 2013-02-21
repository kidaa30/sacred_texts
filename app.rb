require 'slim'
require 'sinatra/base'
require 'sinatra/twitter-bootstrap'

class App < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets

  get '/' do
    slim :index
  end

  get '/design' do
    slim :design
  end

  get '/bible' do
    slim :bible
  end

  get '/bible/:query' do
    "bible, #{params[:query]}"
  end

  get '/quran' do
    slim :quran
  end

  get '/quran/:query' do
    "quran, #{params[:query]}"
  end

end
