class App < Sinatra::Base

  get '/quran' do
    slim :quran
  end

  # Single aya
  get %r{/api/v1/quran/suwar/([\d]+)/ayat/([\d]+)} do |sura, aya|
    content_type :json

    result = Quran.find_by_sura_and_aya(sura.to_i, aya.to_i)

    if result.nil?
      status 404
      {"error" => "No results found."}
    else
      result.to_json(except: :id)
    end
  end

  # Base url for complete search, passage lookup
  get '/api/v1/quran/search' do
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
      result = Quran.by_keyword_search(nil, @search, @mode, @num, @page)
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

  # search, per sura
  get %r{/api/v1/quran/suwar/([\w]+)/search} do |sura|
    content_type :json

    if !@search.nil?
      result = Quran.by_keyword_search(sura, @search, @mode, @num, @page)
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
