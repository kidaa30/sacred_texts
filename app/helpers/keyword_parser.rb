require 'sinatra/base'

module Sinatra
  module KeywordParser

    def parse(keywords)
      keywords.split('+')
    end

    def keyword_clause(keyword)
      {:text => {:$regex => "#{keyword}", :$options => 'i'}}
    end
    
  end

  helpers KeywordParser
end
