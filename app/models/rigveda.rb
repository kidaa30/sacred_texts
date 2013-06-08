require_relative './keyword_parser'

class Rigveda
  include MongoMapper::Document

  set_collection_name 'Rigveda'

  key :mandala, Integer
  key :sukta, Integer
  key :rc, Integer
  key :text, String

  def self.by_keyword_search(mandala, sukta, keywords, mode, limit, page)
    clause = KeywordParser.keyword_where_clause(keywords, mode)
    if (!mandala.nil?)
      clause.push({:mandala => mandala.to_i})
    end
    if (!sukta.nil?)
      clause.push({:sukta => sukta.to_i})
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
