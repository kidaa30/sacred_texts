require relative './keyword_parser'

class Rigveda
  include MongoMapper::Document

  set_collection_name 'Rigveda'

  key :mandala, String
  key :sukta, Integer
  key :rc, Integer
  key :text, String

  def serializable_hash(options = {})
    super({:except => :id}.merge(options))
  end
end
