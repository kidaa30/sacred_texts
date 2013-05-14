require_relative './keyword_parser' 

class Bible
  include MongoMapper::Document

  set_collection_name 'Bible'

  key :bookname, String
  key :chapter, Integer
  key :verse, Integer
  key :text, String

  def self.by_keyword_search(book, chapter, keywords, mode, limit, offset)
    clause = KeywordParser.keyword_where_clause(keywords, mode)
    if (!book.nil?)
      clause.push({:bookname => book})
    end
    if (!chapter.nil?)
      clause.push({:chapter => chapter.to_i})
    end
    where(:$and => clause).skip(offset).limit(limit)
  end

  def serializable_hash(options = {})
    super({:except => :id}.merge(options))
  end
end
