require 'spec_helper'

describe NhtsaVin::Query do
  let(:client) { NhtsaVin::Query.new('2G1WT57K291223396') }

  let(:success_response) { File.read(File.join('spec', 'fixtures', 'success.json')) }
  let(:not_found_response) { File.read(File.join('spec', 'fixtures', 'not_found.json')) }

  # let(:xml_error)  { File.read(File.join('spec', 'fixtures', 'error.xml')) }
  # let(:xml_multi)  { File.read(File.join('spec', 'fixtures', 'success_multi.xml')) }
  # let(:xml_single) { File.read(File.join('spec', 'fixtures', 'success_single.xml')) }

  describe '#initialize' do
    it 'stores the complete URL of the request' do
      expect(client.url)
        .to eq 'https://vpic.nhtsa.dot.gov/api/vehicles/decodevin/2G1WT57K291223396?format=json'
    end
  end

  describe '#get' do
    context 'successful response' do
      before do
        allow(client).to receive(:fetch).and_return(success_response)
        client.get #('1G1WT57K291223396')
      end
      it 'fetches json and response is valid' do
        expect(client.response).to eq success_response
        expect(client.valid?).to be true
      end

      context 'its response' do
        let(:response) { client.get }
        it 'returns a struct' do
          expect(response.class).to be Struct::NhtsaResponse
        end
        it 'returns the correct vehicle data' do
          expect(response.year).to eq '2004'
          expect(response.make).to eq 'Cadillac'
          expect(response.model).to eq 'SRX'
          expect(response.body_style).to eq 'Wagon'
          expect(response.doors).to eq 4
        end
        it 'parses out the type' do
          expect(response.type).to eq 'Minivan'
        end
      end
    end

    context 'error response' do
      before do
        allow(client).to receive(:fetch).and_return(not_found_response)
        client.get
      end
      it 'fetches json and response is not valid' do
        expect(client.response).to eq not_found_response
        expect(client.valid?).to be false
      end
      it 'returns nil' do
        expect(client.get).to be_nil
      end
    end
  end
end
