class Bible
  include MongoMapper::Document
  set_collection_name 'Bible'

  key :bookname, String
  key :chapter, Integer
  key :verse, Integer
  key :text, String

  def serializable_hash(options = {})
    super({:except => :id}.merge(options))
  end
end
