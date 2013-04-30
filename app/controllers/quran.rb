class App < Sinatra::Base

  get '/quran' do
    slim :quran
  end

  get %r{/api/v1/quran/([\d]+)/([\d]+)} do |sura, aya|
    content_type :json

    result = Quran.find_by_sura_and_aya(sura.to_i, aya.to_i)

    if result.nil?
      status 404
      {"error" => "No results found."}
    else
      result.to_json(except: :id)
    end
  end

end
