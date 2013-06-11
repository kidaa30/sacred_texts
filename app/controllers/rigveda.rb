class App < Sinatra::Base

  get '/rigveda' do
    slim :rigveda
  end

  # GET rigveda/rcas
  get %r{/api/v1/rigveda/rcas} do
    content_type :json

    result = Rigveda.paginate({:per_page => @num, :page => @page})
    total_count = 9535

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

end
