require 'spec_helper'

describe NhtsaVin do
  let(:vin) { '2G1WT57K291223396' }
  describe '#get' do
    let(:get) { NhtsaVin.get(vin) }
    it 'returns a query' do
      expect(get).to be_a NhtsaVin::Query
    end
  end
  describe '#validate' do
    let(:validate) { NhtsaVin.validate(vin) }
    it 'returns a validation' do
      expect(validate).to be_a NhtsaVin::Validation
    end
  end
end
