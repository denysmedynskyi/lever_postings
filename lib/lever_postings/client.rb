module LeverPostings
  class Client
    attr_reader :connection, :settings

    def initialize(settings:)
      @settings = settings
      @connection = Faraday.new url: settings.url do |conn|
        conn.request :multipart
        conn.request :url_encoded
        conn.adapter :net_http
      end
    end

    def get(path, params = {})
      request :get, path, params
    end

    def post(path, params = {})
      request :post, path, params
    end

    def head(path, params = {})
      request :head, path, params
    end

    def request(method, path, params = {})
      url = "#{settings.api}/#{settings.account}#{path}"
      url += "?key=#{settings.api_key}" if settings.api_key

      if method == :post
        connection.post(url, params)
      else
        connection.params = params
        response = connection.send(method, url)
        if response.success?
          if params[:mode] == "json"
            MultiJson.load(response.body, symbolize_keys: true)
          else
            response.body
          end
        else
          fail LeverPostings::Error.new("#{response.status}: #{response.body}", response.status)
        end
      end
    end
  end
end
