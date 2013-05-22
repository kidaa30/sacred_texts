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
  helpers Sinatra::UrlPaging

  configure do
    MongoMapper.setup({'production' => {'uri' => ENV['MONGODB_URI']}}, 'production')
    set :views, ["./views"]
  end

  # Before filter catches commonly used url params.
  # These are in the request scope.
  before do
    @search = params['search']
    @mode = params['mode']
    @num = (params['num'].to_i > 0 ? params['num'].to_i : 10)
    @page = (params['page'].to_i > 0 ? params['page'].to_i : 1)
  end

  # static pages
  get '/' do
    slim :index
  end

  get '/apidesign' do
    slim :apidesign
  end

end
