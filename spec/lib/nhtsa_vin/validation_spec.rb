require 'spec_helper'

describe NhtsaVin::Validation do
  describe 'attrs' do
    context 'with a valid VIN' do
      let(:validation) { NhtsaVin::Validation.new('19XFB2F89CE308518') }
      it 'has the checksum digit' do
        expect(validation.check).to eq '9'
      end
      it 'parses out the WMI' do
        expect(validation.wmi).to eq '19X'
      end
      it 'parses out the plant ID' do
        expect(validation.plant).to eq 'E'
      end
      it 'parses out the sequence info' do
        expect(validation.seq).to eq '308518'
      end
    end
    context 'with an invalid VIN' do
      let(:validation) { NhtsaVin::Validation.new('WBAEV534X2KM1611') }
      it 'has nil attrs' do
        expect(validation.check).to be_nil
        expect(validation.wmi).to be_nil
        expect(validation.plant).to be_nil
        expect(validation.seq).to be_nil
      end
    end
  end
  describe '#valid?' do
    context 'a valid VIN' do
      it 'validates' do
        expect(NhtsaVin::Validation.new('19XFB2F89CE308518').valid?)
          .to be true
      end
      it 'handles checksums of 10' do
        expect(NhtsaVin::Validation.new('5NPEU46FX6H141974').valid?)
          .to be true
      end
      it 'strips whitespace' do
        expect(NhtsaVin::Validation.new(' 4T1BD1FK5CU061770  ').valid?)
          .to be true
      end
      it 'validates BMW VINs' do
        expect(NhtsaVin::Validation.new('WBAEV534X2KM16113').valid?)
          .to be true
      end
    end
    context 'an invalid VIN' do
      context 'when the vin is too short' do
        let(:validation) { NhtsaVin::Validation.new('WBAEV534X2KM1611') }
        it 'fails' do
          expect(validation.valid?).to be false
          expect(validation.error).to eq 'Invalid VIN format'
        end
      end
      context 'when the vin contains O' do
        let(:validation) { NhtsaVin::Validation.new('WBAEV534X2KM1611O') }
        it 'fails' do
          expect(NhtsaVin).not_to receive(:checksum)
          expect(validation.valid?).to be false
          expect(validation.error).to eq 'Invalid VIN format'
        end
      end
      context 'when the vin contains I' do
        let(:validation) { NhtsaVin::Validation.new('WBAEV534X2KM1611I') }
        it 'fails' do
          expect(NhtsaVin).not_to receive(:checksum)
          expect(validation.valid?).to be false
          expect(validation.error).to eq 'Invalid VIN format'
        end
      end
      context 'fails when the vin contains Q' do
        let(:validation) { NhtsaVin::Validation.new('WBAEV534X2KM1611Q') }
        it 'fails' do
          expect(NhtsaVin).not_to receive(:checksum)
          expect(validation.valid?).to be false
          expect(validation.error).to eq 'Invalid VIN format'
        end
      end
      context 'when the checksum is incorrect' do
        let(:validation) { NhtsaVin::Validation.new('5NPEU46F96H141974') }
        it 'fails' do
          expect(validation.valid?).to be false
          expect(validation.error)
            .to eq 'VIN checksum digit 9 failed to calculate (expected X)'
        end
      end
      context 'when the vin is nil' do
        let(:validation) { NhtsaVin::Validation.new(nil) }
        it 'fails' do
          expect(validation.valid?).to be false
          expect(validation.error).to eq 'Blank VIN provided'
        end
      end
      context 'when high-ascii chars are used' do
        it 'fails' do
          expect(NhtsaVin::Validation.new('∂BAEV534X2KM16113').valid?)
            .to be false
          expect(NhtsaVin::Validation.new('🥃BAEV534X2KM16113').valid?)
            .to be false
          expect(NhtsaVin::Validation.new('WBAEV534X2KM1611').error)
            .to eq 'Invalid VIN format'
        end
      end
    end
  end
end