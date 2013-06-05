class App < Sinatra::Base

  get '/quran' do
    slim :quran
  end

  # Aya

  # get /quran/ayat
  get "/api/v1/quran/ayat" do
    content_type :json

    if @search.nil?
      result = Quran.paginate({:per_page => @num, :page => @page})
      total_count = Quran::AYAT_COUNT
    else
      result = Quran.by_keyword_search(nil, @search, @mode, @num, @page)
      total_count = result.size
    end

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

    if @search.nil?
      result = Quran.by_sura(sura.to_i, @num, @page)
    else
      result = Quran.by_keyword_search(sura, @search, @mode, @num, @page)
    end

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

end
