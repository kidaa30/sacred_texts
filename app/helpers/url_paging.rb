module Sinatra
  module UrlPaging

    def next_page_url(request, current_page)
      update_page(request, current_page + 1)
    end

    def previous_page_url(request, current_page)
      update_page(request, current_page - 1)
    end

    def update_page(request, new_page)
      url = request.base_url + request.fullpath

      if url.include? "page"
        (url).gsub!(/page=\d+/, "page=#{new_page}")
      else
        url += "&page=#{new_page}"
      end

      url
    end
  end

  helpers UrlPaging
end
