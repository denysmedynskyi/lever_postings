module LeverPostings
  class Settings
    attr_accessor :account, :api, :api_key, :url

    def initialize(api:, api_key: nil, account:, url:)
      @api = api
      @api_key = api_key
      @account = account
      @url = url
    end
  end
end
