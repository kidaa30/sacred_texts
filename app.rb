require 'slim'
require 'sinatra/base'
require 'sinatra/twitter-bootstrap'
require 'mongo_mapper'
require 'json'

# load the models and helpers
Dir["./app/models/*.rb"].each { |file| require file }
Dir["./app/helpers/*.rb"].each { |file| require file }

class App < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets

  helpers Sinatra::KeywordParser

  configure do
    MongoMapper.setup({'production' => {'uri' => ENV['MONGODB_URI']}}, 'production')
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

  # Single verse
  get %r{/api/v1/bible/([\w]+)/([\d]+)/([\d]+)} do |book, chapter, verse|
    content_type :json

    result = Bible.find_by_bookname_and_chapter_and_verse(book,
                                                          chapter.to_i,
                                                          verse.to_i)
    if result.nil?
      status 404
      {"error" => "No results found."}.to_json
    else
      result.to_json
    end
  end

  # Base url for complete search, passage lookup
  get '/api/v1/bible/' do
    content_type :json
    passage = params['passage']
    search = params['search']
    type = params['type']

    # cannot be both a passage and a search
    if (!passage.nil? && !search.nil?)
      status 400
      {"error" => "Only one of the parameters 'passage' and 'search' can be specified."}.to_json
    elsif (passage.nil? && !search.nil?)
      result = Bible.all(:$and => keyword_where_clause(search))
      {"results" => result.to_a}.to_json
    else
      # passage
      {"passage" => "todo"}.to_json
    end
  end

  # bible search, per chapter
  get %r{/api/v1/bible/([\w]+)/([\d]+)} do |book, chapter|
    content_type :json
    search = params['search']

    if !search.nil?
      clause = keyword_where_clause(search)
      clause.push({:bookname => book})
      clause.push({:chapter => chapter.to_i})
      result = Bible.all(:$and => clause)
      {"results" => result.to_a}.to_json
    end
  end

  # bible search, per book
  get %r{/api/v1/bible/([\w]+)} do |book|
    content_type :json
    search = params['search']

    if !search.nil?
      clause = keyword_where_clause(search)
      clause.push({:bookname => book})
      result = Bible.all(:$and => clause)
      {"results" => result.to_a}.to_json
    end
  end

  get %r{/api/v1/quran/([\d]+)/([\d]+)} do |sura, aya|
    content_type :json

    result = Quran.find_by_sura_and_aya(sura.to_i, aya.to_i)

    if result.nil?
      status 404
      {"error" => "No results found."}
    else
      result.to_json(except: :id)
    end
  end

end
