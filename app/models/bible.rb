require_relative './keyword_parser' 

class Bible
  include MongoMapper::Document

  set_collection_name 'Bible'

  key :bookname, String
  key :chapter, Integer
  key :verse, Integer
  key :text, String

  def self.by_bookname(book, limit, page)
    where(:bookname => book).limit(limit).skip(limit * (page - 1))
  end

  def self.by_bookname_and_chapter(book, chapter, limit, page)
    where(:bookname => book, :chapter => chapter).limit(limit).skip(limit * (page - 1))
  end

  def self.by_keyword_search(book, chapter, keywords, mode, limit, page)
    clause = KeywordParser.keyword_where_clause(keywords, mode)
    if (!book.nil?)
      clause.push({:bookname => book.capitalize})
    end
    if (!chapter.nil?)
      clause.push({:chapter => chapter.to_i})
    end
    # This does not allow me to retrieve the total result count in a single
    # query
    #
    # where(:$and => clause).paginate({
    #   :per_page => limit,
    #   :page => page,
    # })
    where(:$and => clause).limit(limit).skip(limit * (page - 1))
  end

  def serializable_hash(options = {})
    super({:except => :id}.merge(options))
  end
end
