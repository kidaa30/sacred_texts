class App < Sinatra::Base

  get '/rigveda' do
    slim :rigveda
  end

  # GET rigveda/rcas
  get %r{/api/v1/rigveda/rcas} do
    content_type :json

    if !@search.nil?
      result = Rigveda.by_keyword_search(nil, nil, @search, @mode, @num, @page)
      total_count = result.count
    else
      result = Rigveda.paginate({:per_page => @num, :page => @page})
      total_count = 9535
    end

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "rcas" => result.to_a,
          "total_count" => total_count
        }
      add_paging!(data)
    end
    data.to_json
  end

  # GET rigveda/mandalas/{mandala_id}/rcas
  get %r{/api/v1/rigveda/mandalas/([\d]+)/rcas} do |mandala|
    content_type :json

    if !@search.nil?
      result = Rigveda.by_keyword_search(mandala.to_i, nil, @search, @mode, @num, @page)
    else
      result = Rigveda.by_mandala(mandala.to_i, @num, @page)
    end

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "mandala" => mandala,
          "rcas" => result.to_a,
          "total_count" => result.count
        }
      add_paging!(data)
    end
    data.to_json
  end

  # GET rigveda/mandalas/{mandala}/suktas/{sukta}/rcas/{rc}
  get %r{/api/v1/rigveda/mandalas/([\d]+)/suktas/([\d]+)/rcas/([\d]+)} do |mandala, sukta, rc|
    content_type :json
    result = Rigveda.find_by_mandala_and_sukta_and_rc(mandala.to_i,
                                                      sukta.to_i,
                                                      rc.to_i)

    if result.nil?
      status 404
      {"error" => "No results found."}.to_json
    else
      result.to_json
    end
  end

  # GET rigveda/mandalas/{mandala}/suktas/{sukta}/rcas
  get %r{/api/v1/rigveda/mandalas/([\d]+)/suktas/([\d]+)/rcas} do |mandala, sukta|
    content_type :json

    if !@search.nil?
      result = Rigveda.by_keyword_search(mandala.to_i, sukta.to_i, @search, @mode, @num, @page)
    else
      result = Rigveda.by_mandala_and_sukta(mandala.to_i, sukta.to_i, @num, @page)
    end

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

  # Suktas

  # GET rigveda/mandala/{mandala_id}/suktas/{sukta_id}
  get %r{/api/v1/rigveda/mandalas/([\d]+)/suktas/([\d]+)} do |mandala, sukta|
    redirect to("/api/v1/rigveda/mandalas/#{mandala}/suktas/#{sukta}/rcas")
  end

  # GET rigveda/mandala/{mandala_id}/suktas
  get %r{/api/v1/rigveda/mandalas/([\d]+)/suktas} do |mandala|
    redirect to("/api/v1/rigveda/mandalas/#{mandala}")
  end

  # Mandalas

  # GET /rigveda/mandalas
  get '/api/v1/rigveda/mandalas' do
    content_type :json

    result = Rigveda.mandalas(@num, @page)
    result.each do |mandala|
      mandala["link"] = request.base_url + "/api/v1/rigveda/mandalas/" + mandala["mandala"].to_s
    end

    data =
      {
        "mandalas" => result,
        "total_count" => Rigveda::SUKTAS_PER_MANDALA.size
      }
    add_paging!(data)
    data.to_json
  end

  # GET /rigveda/mandalas/{mandala_id}
  get %r{/api/v1/rigveda/mandalas/([\d]+)} do |mandala|
    content_type :json

    result = Rigveda.suktas_for_mandala(mandala.to_i, @num, @page)
    result.each do |sukta|
      sukta["link"] = request.base_url + "/api/v1/rigveda/mandalas/#{mandala}/suktas/" + sukta["sukta"].to_s
    end

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data = 
        {
          "mandala" => mandala.to_i,
          "suktas" => result,
          "total_count" => Rigveda::SUKTAS_PER_MANDALA[mandala.to_i]
        }
      add_paging!(data)
    end

    data.to_json
  end

end
