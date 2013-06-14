require_relative './keyword_parser'

class Rigveda
  include MongoMapper::Document

  # We hard-code these static values here, instead of going to the db to count
  # them every time.
  SUKTAS_PER_MANDALA =
    {
      1 => 191,
      2 => 43,
      3 => 62,
      4 => 58,
      5 => 87,
      6 => 75,
      7 => 104,
      8 => 103,
      9 => 114,
      10 => 191
    }.freeze

  set_collection_name 'Rigveda'

  key :mandala, Integer
  key :sukta, Integer
  key :rc, Integer
  key :text, String

  def self.mandalas(limit, page)
    result = Array.new
    mandalas = SUKTAS_PER_MANDALA.keys
    mandala_count = SUKTAS_PER_MANDALA.size

    mandalas[[(limit * (page - 1)), mandala_count - limit].min .. [((limit * page) - 1), mandala_count].min].each do |mandala|
      result.push({"mandala" => mandala})
    end

    result
  end

  def self.by_mandala(mandala, limit, page)
    where(:mandala => mandala).limit(limit).skip(limit * (page - 1))
  end

  def self.by_mandala_and_sukta(mandala, sukta, limit, page)
    where(:mandala => mandala, :sukta => sukta).limit(limit).skip(limit * (page - 1))
  end

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
