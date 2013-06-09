class App < Sinatra::Base

  get '/bible' do
    slim :bible
  end

  # Verses

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
      result = Bible.by_book(book.capitalize, @num, @page)
    end

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "book" => book.capitalize,
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
    result = Bible.find_by_book_and_chapter_and_verse(book.capitalize,
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
      result = Bible.by_book_and_chapter(book.capitalize, chapter.to_i, @num, @page)
    end

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "book" => book.capitalize,
          "chapter" => chapter.to_i,
          "verses" => result.to_a,
          "total_count" => result.count
        }
      add_paging!(data)
    end
    data.to_json
  end

  # Chapters

  # GET bible/books/{bookname}/chapters/{chapter}
  get %r{/api/v1/bible/books/([\w]+)/chapters/([\d]+)} do |book, chapter|
    redirect to("/api/v1/bible/books/#{book}/chapters/#{chapter}/verses")
  end

  # Books

  # GET bible/books
  get '/api/v1/bible/books' do
    content_type :json

    result = Bible.books(@num, @page)
    result.each do |book|
      book["link"] = request.base_url + "/api/v1/bible/books/" + book["book"]
    end

    data =
      {
        "books" => result,
        "total_count" => Bible::CHAPTERS_PER_BOOK.size
      }
    add_paging!(data)
    data.to_json
  end

  # GET bible/books/{bookname}
  get %r{/api/v1/bible/books/([\w]+)} do |book|
    content_type :json

    result = Bible.chapters_for_book(book, @num, @page)
    result.each do |chapter|
      chapter["link"] = request.base_url + "/api/v1/bible/books/#{book}/chapters/" + chapter["chapter"].to_s
    end

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "book" => book,
          "chapters" => result,
          "total_count" => Bible::CHAPTERS_PER_BOOK[book]
        }
      add_paging!(data)
    end

    data.to_json
  end

end
