require 'sinatra/base'

module Sinatra
  module KeywordParser

    def keyword_where_clause(keywords)
      params = Array.new

      # The '+' char is replaced with " " in the params hash.  Don't know why.
      keywords.split.each do |keyword|
        params.push create_clause(keyword)
      end

      params
    end

    def create_clause(keyword)
      {:text => {:$regex => "#{keyword}", :$options => 'i'}}
    end
    
  end

  helpers KeywordParser
end
