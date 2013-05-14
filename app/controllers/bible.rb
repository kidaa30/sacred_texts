class App < Sinatra::Base

  get '/bible' do
    slim :bible
  end

  # Single verse
  get %r{/api/v1/bible/([\w]+)/([\d]+)/([\d]+)(\.[\w]+)?} do |book, chapter, verse, type|

    result = Bible.find_by_bookname_and_chapter_and_verse(book,
                                                          chapter.to_i,
                                                          verse.to_i)

    if result.nil?
      status 404
      format({"error" => "No results found."}, type)
    else
      format(result, type)
    end
  end

  # Base url for complete search, passage lookup
  get '/api/v1/bible' do
    passage = params['passage']
    search = params['search']
    type = params['type']

    # cannot be both a passage and a search
    if (!passage.nil? && !search.nil?)
      status 400
      format({"error" => "Only one of the parameters 'passage' and 'search' can be specified."}, type)
    elsif (passage.nil? && !search.nil?)
      mode = params['mode']
      num = (params['num'].to_i > 0 ? params['num'].to_i : 10)
      offset = params['start'].to_i
      result = Bible.by_keyword_search(nil, nil, search, mode, num, offset)
      data = {"results" => result.to_a}
      format(data, type)
    else
      # passage
      {"passage" => "todo"}.to_json
    end
  end

  # bible search, per chapter
  get %r{/api/v1/bible/([\w]+)/([\d]+)} do |book, chapter|
    content_type :json
    search = params['search']

    if !search.nil?
      mode = params['mode']
      num = (params['num'].to_i > 0 ? params['num'].to_i : 10)
      offset = params['start'].to_i
      result = Bible.by_keyword_search(book, chapter, search, mode, num, offset)
      {"results" => result.to_a}.to_json
    end
  end

  # bible search, per book
  get %r{/api/v1/bible/([\w]+)} do |book|
    content_type :json
    search = params['search']

    if !search.nil?
      mode = params['mode']
      num = (params['num'].to_i > 0 ? params['num'].to_i : 10)
      offset = params['start'].to_i
      result = Bible.by_keyword_search(book, nil, search, mode, num, offset)
      {"results" => result.to_a}.to_json
    end
  end
end
