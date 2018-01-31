require "spec_helper"

describe LeverPostings::Settings do
  subject(:settings) { described_class.new(api: 'postings', account: 'leverdemo', api_key: 'secret', url: 'https://api.lever.co/v0') }

  describe "#initialize" do
    describe '#account' do
      specify do
        expect(settings.account).to eq('leverdemo')
      end
    end

    describe '#api' do
      specify do
        expect(settings.api).to eq('postings')
      end
    end

    describe '#api_key' do
      specify do
        expect(settings.api_key).to eq('secret')
      end
    end

    describe '#url' do
      specify do
        expect(settings.url).to eq('https://api.lever.co/v0')
      end
    end
  end
end
