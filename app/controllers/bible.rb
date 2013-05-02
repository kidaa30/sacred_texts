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
    mode = params['mode']
    type = params['type']

    # cannot be both a passage and a search
    if (!passage.nil? && !search.nil?)
      status 400
      format({"error" => "Only one of the parameters 'passage' and 'search' can be specified."}, type)
    elsif (passage.nil? && !search.nil?)
      result = Bible.all(:$and => keyword_where_clause(search))
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
    mode = params['mode']

    if !search.nil?
      clause = keyword_where_clause(search)
      clause.push({:bookname => book})
      clause.push({:chapter => chapter.to_i})
      result = Bible.all(:$and => clause)
      {"results" => result.to_a}.to_json
    end
  end

  # bible search, per book
  get %r{/api/v1/bible/([\w]+)} do |book|
    content_type :json
    search = params['search']
    mode = params['mode']

    if !search.nil?
      clause = keyword_where_clause(search)
      clause.push({:bookname => book})
      result = Bible.all(:$and => clause)
      {"results" => result.to_a}.to_json
    end
  end
end
