require 'helper'

describe ActivePayment::Models::Payee do
  describe 'initialize' do
    it 'should raise error if trying to initialize without any parameters' do
      expect { ActivePayment::Models::Payee.new }.to raise_error(ArgumentError)
    end

    it 'should raise error if trying to initialize without id' do
      expect { ActivePayment::Models::Payee.new(paypal_identifier: 'test@test.com') }.to raise_error(ArgumentError)
    end

    it 'should raise error if trying to initialize without identifier' do
      expect { ActivePayment::Models::Payee.new(id: 1) }.to raise_error(ArgumentError)
    end

    it 'should not raise error when using id/identifier parameters' do
      expect { ActivePayment::Models::Payee.new(id: 1, paypal_identifier: 'test@test.com') }.not_to raise_error
    end

    it 'should set primary default value to false' do
      service = ActivePayment::Models::Payee.new(id: 1, paypal_identifier: 'test@test.com')
      expect(service.primary).to eq(false)
    end

    it 'should allow to set primary value' do
      service = ActivePayment::Models::Payee.new(id: 1, paypal_identifier: 'test@test.com', primary: true)
      expect(service.primary).to eq(true)
    end
  end

  describe 'to_paypal_hash' do
    it 'should returns expect value' do
      service = ActivePayment::Models::Payee.new(id: 1, paypal_identifier: 'test@test.com')
      expect(service.to_paypal_hash.class).to eq(Hash)
      expect(service.to_paypal_hash[:email]).to eq('test@test.com')
      expect(service.to_paypal_hash[:primary]).to eq(false)
    end
  end
end
