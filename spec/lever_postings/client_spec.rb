require "spec_helper"

describe LeverPostings::Client do
  subject(:request_client) { described_class.new(settings: settings) }
  let(:settings) { double(api: 'postings', account: 'leverdemo', api_key: nil, url: 'https://api.lever.co/v0') }

  describe "#get" do
    it "applies params to requests" do
      expect(request_client).to receive(:request).with(:get, '', mode: "json")
      VCR.use_cassette("postings") do
        request_client.get('', mode: "json")
      end
    end
  end

  describe "#post" do
    it "applies params to requests" do
      expect(request_client).to receive(:request).with(:post,
                                                "491029da-9b63-4208-83f6-c976b6fe2ac5", api_key: "123")
      VCR.use_cassette("apply-to-posting") do
        request_client.post("491029da-9b63-4208-83f6-c976b6fe2ac5", api_key: "123")
      end
    end
  end

  describe "#head" do
    it "applies params to requests" do
      expect(request_client).to receive(:request).with(:head, "1f1395a3-b023-492f-9671-7dbc535ecf73", mode: "json")
      VCR.use_cassette("check-posting-existence") do
        request_client.head("1f1395a3-b023-492f-9671-7dbc535ecf73", mode: "json")
      end
    end
  end

  describe "#request" do
    it "returns parsed json when request is successful" do
      VCR.use_cassette("postings") do
        postings = request_client.request(:get, '', mode: "json")
        expect(postings).to be_an_instance_of(Array)
        expect(postings.first[:text]).to eq "Account Executive"
      end
    end

    it "raises an error when request fails" do
      VCR.use_cassette("failed-request") do
        expect { request_client.request(:get, "/alksdjflajdsf") }.to raise_error LeverPostings::Error
      end
    end
  end
end
