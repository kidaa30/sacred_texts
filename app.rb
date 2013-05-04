require 'slim'
require 'sinatra/base'
require 'sinatra/twitter-bootstrap'
require 'mongo_mapper'
require 'json'

# load the models and helpers
Dir["./app/helpers/*.rb"].each { |file| require file }
Dir["./app/models/*.rb"].each { |file| require file }
Dir["./app/controllers/*.rb"].each { |file| require file }

class App < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets

  helpers Sinatra::ContentTypes

  configure do
    MongoMapper.setup({'production' => {'uri' => ENV['MONGODB_URI']}}, 'production')
    set :views, ["./views"]
  end

  # static pages
  get '/' do
    slim :index
  end

  get '/apidesign' do
    slim :apidesign
  end

end
