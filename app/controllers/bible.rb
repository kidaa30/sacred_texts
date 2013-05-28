class App < Sinatra::Base

  get '/bible' do
    slim :bible
  end

  # bible/books/chapters/{x}/verses/{y}
  get %r{/api/v1/bible/books/([\w]+)/chapters/([\d]+)/verses/([\d]+)(\.[\w]+)?} do |book, chapter, verse, type|

    result = Bible.find_by_bookname_and_chapter_and_verse(book.capitalize,
                                                          chapter.to_i,
                                                          verse.to_i)

    if result.nil?
      status 404
      format({"error" => "No results found."}, type)
    else
      format(result, type)
    end
  end

  # bible/books/chapters/{x}/verses
  get %r{/api/v1/bible/books/([\w]+)/chapters/([\d]+)/verses} do |book, chapter|
    content_type :json

    result = Bible.by_bookname_and_chapter(book.capitalize, chapter.to_i, @num, @page)

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

  # Base url for complete search, passage lookup
  get '/api/v1/bible/search' do
    passage = params['passage']
    type = params['type']

    # cannot be both a passage and a search
    if (!passage.nil? && !@search.nil?)
      status 400
      data = 
        {
          "error" => "Only one of the parameters 'passage' and 'search' can be specified."
        }
    elsif !@search.nil?
      result = Bible.by_keyword_search(nil, nil, @search, @mode, @num, @page)
      data =
        {
          "results" => result.to_a,
          "total_count" => result.count
        }
      add_paging!(data)
    elsif !passage.nil?
      data = {"passage" => "todo"}
    else
      data =
        {
          "error" => "This resource is only available for searching via the search url parameter."
        }
    end
    format(data, type)
  end

  # bible search, per chapter
  get %r{/api/v1/bible/books/([\w]+)/chapters/([\d]+)/search} do |book, chapter|
    content_type :json

    if !@search.nil?
      result = Bible.by_keyword_search(book, chapter, @search, @mode, @num, @page)
      data =
        {
          "results" => result.to_a,
          "total_count" => result.count
        }
      add_paging!(data)
      data.to_json
    else
      {
        "error" => "This resource is only available for searching via the search url parameter."
      }.to_json
    end
  end

  # bible search, per book
  get %r{/api/v1/bible/books/([\w]+)/search} do |book|
    content_type :json

    if !@search.nil?
      result = Bible.by_keyword_search(book, nil, @search, @mode, @num, @page)
      data =
        {
          "results" => result.to_a,
          "total_count" => result.count
        }
      add_paging!(data)
      data.to_json
    else
      {
        "error" => "This resource is only available for searching via the search url parameter."
      }.to_json
    end
  end
end
