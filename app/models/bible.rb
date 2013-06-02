require_relative './keyword_parser' 

class Bible
  include MongoMapper::Document

  # We hard-code these static values here, instead of going to the db to count
  # them every time.
  CHAPTERS_PER_BOOK =
  {
    "Genesis" => 50,
    "Exodus" => 40,
    "Leviticus" => 27,
    "Numbers" => 36,
    "Deuteronomy" => 34,
    "Joshua" => 24,
    "Judges" => 21,
    "Ruth" => 4,
    "1 Samuel" => 31,
    "2 Samuel" => 24,
    "1 Kings" => 22,
    "2 Kings" => 25,
    "1 Chronicles" => 29,
    "2 Chronicles" => 36,
    "Ezra" => 10,
    "Nehemiah" => 13,
    "Esther" => 10,
    "Job" => 42,
    "Psalm" => 150,
    "Proverbs" => 31,
    "Ecclesiastes" => 12,
    "Song of Solomon" => 8,
    "Isaiah" => 66,
    "Jeremiah" => 52,
    "Lamentations" => 5,
    "Ezekiel" => 48,
    "Daniel" => 12,
    "Hosea" => 14,
    "Joel" => 3,
    "Amos" => 9,
    "Obadiah" => 1,
    "Jonah" => 4,
    "Micah" => 7,
    "Nahum" => 3,
    "Habakkuk" => 3,
    "Zephaniah" => 3,
    "Haggai" => 2,
    "Zechariah" => 14,
    "Malachi" => 4,
    "Matthew" => 28,
    "Mark" => 16,
    "Luke" => 24,
    "John" => 21,
    "Acts" => 28,
    "Romans" => 16,
    "1 Corinthians" => 16,
    "2 Corinthians" => 13,
    "Galatians" => 6,
    "Ephesians" => 6,
    "Philippians" => 4,
    "Colossians" => 4,
    "1 Thessalonians" => 5,
    "2 Thessalonians" => 3,
    "1 Timothy" => 6,
    "2 Timothy" => 4,
    "Titus" => 3,
    "Philemon" => 1,
    "Hebrews" => 13,
    "James" => 5,
    "1 Peter" => 5,
    "2 Peter" => 3,
    "1 John" => 5,
    "2 John" => 1,
    "3 John" => 1,
    "Jude" => 1,
    "Revelation" => 22
  }.freeze

  set_collection_name 'Bible'

  key :bookname, String
  key :chapter, Integer
  key :verse, Integer
  key :text, String

  def self.books(limit, page)
    result = Array.new
    books = CHAPTERS_PER_BOOK.keys

    books[(limit * (page - 1))..((limit * page) - 1)].each do |bookname|
      result.push({"bookname" => bookname})
    end

    result
  end

  def self.chapters_for_book(book, limit, page)
    result = Array.new
    count = CHAPTERS_PER_BOOK[book]

    if count.nil?
      return result
    end

    for i in (1 + limit * (page - 1))..[limit * page, count].min
      result.push({"chapter" => i})
    end
    
    result
  end

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
