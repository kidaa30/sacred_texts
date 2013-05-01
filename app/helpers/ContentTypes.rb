module Sinatra
  module ContentTypes
    CONTENT_TYPES = {'xml' => :xml, 'json' => :json}
    CONTENT_TYPES.default = :json

    def format(data, type)
      if !type.nil?
        # strip off leading "." when it exists.
        # This is not needed when type is passed as a param.
        if type.starts_with?(".")
          type = type[1..-1]
        end
      end

      content_type CONTENT_TYPES[type], charset: 'utf-8'
      case type
      when 'xml'
        data.to_xml
      else 'json'
        data.to_json
      end
    end
  end

  helpers ContentTypes
end
