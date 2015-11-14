require 'helper'

describe ActivePayment::Models::Payable do
  describe 'initialize' do
    it 'should not raise any error if calling initialize without any parameter' do
      expect { ActivePayment::Models::Payable.new }.not_to raise_error
    end

    it 'should set attributes when passing a hash' do
      service = ActivePayment::Models::Payable.new({
        id: 1,
        class: 'PayableObj',
        description: 'desc',
        amount: 1000,
        reference_number: 'ABC123',
        number: 999,
        quantity: 300,
        external_id: '100',
        tax: 123,
        shipping: 456
      })

      expect(service.id).to eq(1)
      expect(service.class).to eq('PayableObj')
      expect(service.description).to eq('desc')
      expect(service.amount).to eq(1000)
      expect(service.reference_number).to eq('ABC123')
      expect(service.external_id).to eq('100')
      expect(service.tax).to eq(123)
      expect(service.shipping).to eq(456)
      expect(service.number).to eq(999)
      expect(service.quantity).to eq(300)
    end

    it 'should set default currency value to USD if not set' do
      service = ActivePayment::Models::Payable.new({
        id: 1,
        class: 'PayableObj',
        description: 'desc',
        amount: 1000,
        reference_number: 'ABC123',
        external_id: '100',
        shipping: 456
      })
      expect(service.currency).to eq('USD')
    end

    it 'should set default tax value to 0 if not set' do
      service = ActivePayment::Models::Payable.new({
        id: 1,
        class: 'PayableObj',
        description: 'desc',
        amount: 1000,
        reference_number: 'ABC123',
        external_id: '100',
        shipping: 456
      })
      expect(service.tax).to eq(0)
    end

    it 'should set default shipping value to 0 if not set' do
      service = ActivePayment::Models::Payable.new({
        id: 1,
        class: 'PayableObj',
        description: 'desc',
        amount: 1000,
        reference_number: 'ABC123',
        external_id: '100',
        tax: 123
      })
      expect(service.shipping).to eq(0)
    end
  end

  it 'should set default number value to 1 if not set' do
    service = ActivePayment::Models::Payable.new({
      id: 1,
      class: 'PayableObj',
      description: 'desc',
      amount: 1000,
      reference_number: 'ABC123',
      external_id: '100',
      shipping: 456
    })
    expect(service.number).to eq(1)
  end

  it 'should set default quantity value to 1 if not set' do
    service = ActivePayment::Models::Payable.new({
      id: 1,
      class: 'PayableObj',
      description: 'desc',
      amount: 1000,
      reference_number: 'ABC123',
      external_id: '100',
      shipping: 456
    })
    expect(service.quantity).to eq(1)
  end

  describe 'to_paypal_hash' do
    it 'should returns expect value' do
      service = ActivePayment::Models::Payable.new({
        id: 1,
        class: 'PayableObj',
        description: 'desc',
        amount: 1000,
        reference_number: 'ABC123',
        external_id: '100',
        tax: 123,
        shipping: 456
      })
      expect(service.to_paypal_hash.class).to eq(Hash)
      expect(service.to_paypal_hash[:name]).to eq('desc')
      expect(service.to_paypal_hash[:amount]).to eq(1000)
      expect(service.to_paypal_hash[:number]).to eq(1)
      expect(service.to_paypal_hash[:quantity]).to eq(1)
    end
  end
end
