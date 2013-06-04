#
# Note that there was no need to pass request scoped variables as params into
# these methods, because request scope variables were already visible to the
# helper.
#
module Sinatra
  module UrlPaging

    def add_paging!(data)
      # next page link
      if (data["total_count"] > @num * @page)
        data["next_page"] = update_page(@page + 1)
      end

      # If page is greater than 1 and not out of bounds, provide link to previous page.
      if (@page > 1)
        data["previous_page"] = update_page(@page - 1)
      end
    end

    private

    def update_page(new_page)
      url = request.base_url + request.fullpath

      #if url.include? "page"
      if !params['page'].nil?
        url.gsub!(/page=\d+/, "page=#{new_page}")
      else
        if url.include? "?"
          url += "&page=#{new_page}"
        else
          url += "?page=#{new_page}"
        end
      end

      url
    end
  end

  helpers UrlPaging
end
