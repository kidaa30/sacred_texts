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
        data["next_page"] = next_page_url
      end

      # previous page link
      if (@page > 1)
        data["previous_page"] = previous_page_url
      end
    end

    private

    def next_page_url
      update_page(@page + 1)
    end

    def previous_page_url
      update_page(@page - 1)
    end

    def update_page(new_page)
      url = request.base_url + request.fullpath

      if url.include? "page"
        url.gsub!(/page=\d+/, "page=#{new_page}")
      else
        url += "&page=#{new_page}"
      end

      url
    end
  end

  helpers UrlPaging
end
