require_relative './keyword_parser' 

class Bible
  include MongoMapper::Document

  set_collection_name 'Bible'

  key :bookname, String
  key :chapter, Integer
  key :verse, Integer
  key :text, String

  def self.by_global_search(keywords, mode, limit)
    clause = KeywordParser.keyword_where_clause(keywords, mode)
    where(:$and => clause).limit(limit)
  end

  def self.by_book_search(book, keywords, mode, limit)
    clause = KeywordParser.keyword_where_clause(keywords, mode)
    clause.push({:bookname => book})
    where(:$and => clause).limit(limit)
  end

  def self.by_chapter_search(book, chapter, keywords, mode, limit)
    clause = KeywordParser.keyword_where_clause(keywords, mode)
    clause.push({:bookname => book})
    clause.push({:chapter => chapter.to_i})
    where(:$and => clause).limit(limit)
  end

  def serializable_hash(options = {})
    super({:except => :id}.merge(options))
  end
end
