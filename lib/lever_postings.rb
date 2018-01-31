require "faraday"
require "hashie"
require "multi_json"
require 'pry'

require "lever_postings/settings"
require "lever_postings/client"
require "lever_postings/error"
require "lever_postings/posting"
require "lever_postings/version"

module LeverPostings
  SETTINGS = {
    api: 'postings',
    url: 'https://api.lever.co/v0'
  }

  class << self
    def apply(account, api_key, params)
      settings = LeverPostings::Settings.new(account: account, api_key: api_key, **LeverPostings::SETTINGS)
      postings_api = LeverPostings::Client.new(settings: settings)
      posting_id = params[:posting_id]
      postings_api.post("/#{posting_id}", params)
    end

    def postings(account, params = {})
      params[:mode] ||= "json"
      settings = LeverPostings::Settings.new(account: account, api: LeverPostings::API, url: 'https://api.lever.co/v0')
      postings_api = LeverPostings::Client.new(settings: settings)
      results = postings_api.get(params.delete(:id), params)

      if params.key?(:mode) && params[:mode] == "html"
        results
      else
        Posting.from_json(results)
      end
    end
  end
end
