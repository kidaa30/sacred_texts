require 'sinatra/base'

module Sinatra
  module KeywordParser

    def keyword_where_clause(keywords, mode)
      params = Array.new

      # The '+' char is replaced with " " in the params hash.  Don't know why.
      keywords.split.each do |keyword|
        params.push create_clause(keyword, mode)
      end

      params
    end

    def create_clause(keyword, mode)
      if "whole".eql? mode
        {:text => {:$regex => "\\b#{keyword}\\b", :$options => 'i'}}
      else
        {:text => {:$regex => "#{keyword}", :$options => 'i'}}
      end
    end
    
  end

  helpers KeywordParser
end
