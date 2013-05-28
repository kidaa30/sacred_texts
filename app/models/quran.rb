require_relative './keyword_parser' 

class Quran
  include MongoMapper::Document
  set_collection_name 'Quran'

  key :sura, Integer
  key :aya, Integer
  key :text, String

  def self.by_sura(sura, limit, page)
    where(:sura => sura).limit(limit).skip(limit * (page - 1))
  end

  def self.by_keyword_search(sura, keywords, mode, limit, page)
    clause = KeywordParser.keyword_where_clause(keywords, mode)
    if (!sura.nil?)
      clause.push({:sura => sura.to_i})
    end

    where(:$and => clause).limit(limit).skip(limit * (page - 1))
  end

  def serializable_hash(options = {})
    super({:except => :id}.merge(options))
  end
end
