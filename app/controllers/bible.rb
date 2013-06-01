class App < Sinatra::Base

  get '/bible' do
    slim :bible
  end

  # GET bible/verses
  get %r{/api/v1/bible/verses} do
    content_type :json

    if !@search.nil?
      result = Bible.by_keyword_search(nil, nil, @search, @mode, @num, @page)
      total_count = result.count
    else
      result = Bible.paginate({:per_page => @num, :page => @page})
      total_count = 31103
    end

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "verses" => result.to_a,
          "total_count" => total_count
        }
      add_paging!(data)
    end
    data.to_json
  end

  # GET bible/books/{book}/verses
  get %r{/api/v1/bible/books/([\w]+)/verses} do |book|
    content_type :json

    if !@search.nil?
      result = Bible.by_keyword_search(book, nil, @search, @mode, @num, @page)
    else
      result = Bible.by_bookname(book.capitalize, @num, @page)
    end

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "verses" => result.to_a,
          "total_count" => result.count
        }
      add_paging!(data)
    end
    data.to_json
  end

  # GET bible/books/{book}/chapters/{chapter}/verses/{verse}
  get %r{/api/v1/bible/books/([\w]+)/chapters/([\d]+)/verses/([\d]+)} do |book, chapter, verse|
    content_type :json
    result = Bible.find_by_bookname_and_chapter_and_verse(book.capitalize,
                                                          chapter.to_i,
                                                          verse.to_i)

    if result.nil?
      status 404
      {"error" => "No results found."}.to_json
    else
      result.to_json 
    end
  end

  # GET bible/books/{book}/chapters/{chapter}/verses
  get %r{/api/v1/bible/books/([\w]+)/chapters/([\d]+)/verses} do |book, chapter|
    content_type :json

    if !@search.nil?
      result = Bible.by_keyword_search(book, chapter, @search, @mode, @num, @page)
    else
      result = Bible.by_bookname_and_chapter(book.capitalize, chapter.to_i, @num, @page)
    end

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "verses" => result.to_a,
          "total_count" => result.count
        }
      add_paging!(data)
    end
    data.to_json
  end

end
