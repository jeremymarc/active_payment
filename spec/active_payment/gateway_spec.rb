require 'helper'

describe ActivePayment::Gateway do
  it 'set the paypal express checkout gateway' do
    gateway = ActivePayment::Gateway.new('paypal_express_checkout')
    expect(gateway.gateway.class).to eq(ActivePayment::Gateways::PaypalExpressCheckout)
  end

  it 'set the paypal adaptive payment gateway' do
    gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
    expect(gateway.gateway.class).to eq(ActivePayment::Gateways::PaypalAdaptivePayment)
  end

  it 'call setup_purchase on the gateway' do
    gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
    return_url = "http://return.url"
    purchase_token = "token"
    ip_address = "127.0.0.1"

    expect(gateway.gateway).to receive(:setup_purchase).and_return(return_url)
    expect(gateway.gateway).to receive(:purchase_token).and_return(purchase_token)
    allow(gateway.gateway).to receive(:sales).and_return([])
    gateway.setup_purchase([], ip_address)
  end

  it 'must create transactions after calling setup_purchase' do
    gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
    return_url = "http://return.url"
    purchase_token = "token"
    ip_address = "127.0.0.1"

    allow(gateway.gateway).to receive(:setup_purchase).and_return(return_url)
    allow(gateway.gateway).to receive(:purchase_token).and_return(purchase_token)
    allow(gateway.gateway).to receive(:sales).and_return([])
    expect(gateway).to receive(:create_transactions).with(ip_address)
    gateway.setup_purchase([], ip_address)
  end

  it 'raise NoTransactionError when calling verify_purchase with invalid external_id' do
    external_id = 1
    raw_data = {}

    expect {
      gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
      gateway.verify_purchase(external_id, raw_data)
    }.to raise_error(ActivePayment::NoTransactionError)
  end

  it 'set the transactions to error if gateway response is wrong' do
    external_id = 1
    raw_data = {}
    transaction = create(:transaction)

    expect {
      gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
      allow(ActivePayment::Transaction).to receive(:where).with(external_id: external_id).and_return([transaction])
      allow(gateway.gateway).to receive(:verify_purchase).and_return(false)
      expect(gateway).to receive(:transactions_error)

      gateway.verify_purchase(external_id, raw_data)
    }.to raise_error(ActivePayment::InvalidGatewayResponseError)
  end

  it 'set the transactions to success if gateway response is ok' do
    external_id = 1
    raw_data = {}
    transaction = create(:transaction)

    gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
    allow(ActivePayment::Transaction).to receive(:where).with(external_id: external_id).and_return([transaction])
    allow(gateway.gateway).to receive(:verify_purchase).and_return(true)
    expect(gateway).to receive(:transactions_success)

    gateway.verify_purchase(external_id, raw_data)
  end

  it 'call livemode? on the gateway' do
    gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
    expect(gateway.gateway).to receive(:livemode?)
    gateway.livemode?
  end
  #
  it 'call external_id_from_request on the gateway' do
    request = {}
    gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
    expect(gateway.gateway).to receive(:external_id_from_request).with(request)
    gateway.external_id_from_request(request)
  end
end

