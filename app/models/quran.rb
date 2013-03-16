class Quran
  include MongoMapper::Document
  set_collection_name 'Quran'

  key :sura, Integer
  key :aya, Integer
  key :text, String
end
