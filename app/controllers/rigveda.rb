class App < Sinatra::Base

  get '/rigveda' do
    slim :rigveda
  end

  # GET rigveda/mandalas/{mandala}/suktas/{sukta}/rcas/{rc}
  get %r{/api/v1/rigveda/mandalas/([\d]+)/suktas/([\d]+)/rcas/([\d]+)(\.[\w]+)?} do |mandala, sukta, rc, type|

    result = Rigveda.find_by_mandala_and_sukta_and_rc(mandala.to_i,
                                                      sukta.to_i,
                                                      rc.to_i)

    if result.nil?
      status 404
      format({"error" => "No results found."}, type)
    else
      format(result, type)
    end
  end

  # GET rigveda/mandalas/{mandala}/suktas/{sukta}/rcas
  get %r{/api/v1/rigveda/mandalas/([\d]+)/suktas/([\d]+)/rcas} do |mandala, sukta|
    content_type :json

    result = Rigveda.by_mandala_and_sukta(mandala.to_i, sukta.to_i, @num, @page)

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "rcas" => result.to_a,
          "total_count" => result.count
        }
      add_paging!(data)
    end
    data.to_json
  end

  # Base url for complete search, passage lookup
  get '/api/v1/rigveda/search' do
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
      result = Rigveda.by_keyword_search(nil, nil, @search, @mode, @num, @page)
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

  # rigveda search, per sukta
  get %r{/api/v1/rigveda/mandalas/([\d]+)/suktas/([\d]+)/search} do |mandala, sukta|
    content_type :json

    if !@search.nil?
      result = Rigveda.by_keyword_search(mandala, sukta, @search, @mode, @num, @page)
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

  # rigveda search, per mandala
  get %r{/api/v1/rigveda/mandala/([\d]+)/search} do |mandala|
    content_type :json

    if !@search.nil?
      result = Bible.by_keyword_search(mandala, nil, @search, @mode, @num, @page)
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
