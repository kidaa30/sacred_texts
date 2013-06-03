class App < Sinatra::Base

  get '/quran' do
    slim :quran
  end

  # Aya

  # get /quran/ayat
  get "/api/v1/quran/ayat" do
    content_type :json

    result = Quran.paginate({:per_page => @num, :page => @page})
    total_count = Quran::AYAT_COUNT

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data = 
        {
          "ayat" => result.to_a,
          "total_count" => total_count
        }
      add_paging!(data)
    end
    data.to_json
  end

  # GET /quran/suwar/{x}/ayat/{y}
  get %r{/api/v1/quran/suwar/([\d]+)/ayat/([\d]+)} do |sura, aya|
    content_type :json

    result = Quran.find_by_sura_and_aya(sura.to_i, aya.to_i)

    if result.nil?
      status 404
      {"error" => "No results found."}
    else
      result.to_json
    end
  end

  # GET /quran/suwar/{x}/ayat
  get %r{/api/v1/quran/suwar/([\d]+)/ayat} do |sura|
    content_type :json

    result = Quran.by_sura(sura.to_i, @num, @page)

    if result.empty?
      status 404
      data = {"error" => "No results found."}
    else
      data =
        {
          "ayat" => result.to_a,
          "total_count" => result.count
        }
      add_paging!(data)
    end
    data.to_json
  end

  # Sura

  # /quran/suwar
  get "/api/v1/quran/suwar" do
    content_type :json

    result = Quran.suwar(@num, @page)
    result.each do |sura|
      sura["link"] = request.base_url + "/api/v1/quran/suwar/" + sura["sura"].to_s
    end

    data = 
      {
        "suwar" => result,
        "total_count" => Quran::SUWAR_COUNT
      }
    add_paging!(data)
    data.to_json
  end

  # /quran/suwar/{suwar_id}
  get %r{/api/v1/quran/suwar/([\d]+)} do |sura|
    redirect to("/api/v1/quran/suwar/#{sura}/ayat")
  end

  # Base url for complete search, passage lookup
  get '/api/v1/quran/search' do
    type = params['type']

    if !@search.nil?
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
