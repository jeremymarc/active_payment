require 'helper'

describe ActivePayment::Gateways::PaypalAdaptivePayment do
  before(:each) do
    @payer = Payer.new
    @payee = Payee.new
    @payable = Payable.new
    @sale = ActivePayment::Models::Sale.new(payable: @payable, payer: @payer, payee: @payee)
    @payee2 = Payee.new
    @payee2.paypal_identifier = 'test2@paypal.com'
    @payee3 = Payee.new
    @payee3.paypal_identifier = 'test3@paypal.com'
    @sale2 = ActivePayment::Models::Sale.new(payable: @payable, payer: @payer, payee: @payee2)
    @sale3 = ActivePayment::Models::Sale.new(payable: @payable, payer: @payer, payee: @payee3)

    @sales = ActivePayment::Models::Sales.new([@sale, @sale2, @sale3])
    @gateway = ActivePayment::Gateways::PaypalAdaptivePayment.new
    class SuccessMockResponse
      def success?
        true
      end

      def [](payKey)
        "payKey"
      end
    end
    class FailedMockResponse
      def success?
        false
      end
    end
    class SuccessVerifyPurchaseMockResponse
      def acknowledge
        true
      end
      def complete?
        true
      end
      def [](request)
        "pay_key"
      end
    end
    @success_gateway_response = SuccessMockResponse.new
    @failed_gateway_response = FailedMockResponse.new
    @success_verify_response = SuccessVerifyPurchaseMockResponse.new
  end

  describe 'initialize' do
    it 'initialize the correct gateway' do
      expect(ActiveMerchant::Billing::PaypalAdaptivePayment).to receive(:new).once
      ActivePayment::Gateways::PaypalAdaptivePayment.new
    end
  end

  describe 'setup_purchase' do
    it 'call setup_purchase on the gateway' do
      expect_any_instance_of(ActiveMerchant::Billing::PaypalAdaptivePayment).to receive(:setup_purchase).once.and_return(@success_gateway_response)
      @gateway.setup_purchase(@sales)
    end

    it 'raise InvalidGatewayResponse if response is not success' do
      expect {
        expect_any_instance_of(ActiveMerchant::Billing::PaypalAdaptivePayment).to receive(:setup_purchase).once.and_return(@failed_gateway_response)
        @gateway.setup_purchase(@sales)
      }.to raise_error(ActivePayment::InvalidGatewayResponseError)
    end
  end

  describe 'verify_purchase' do
    it 'calls notification on PaypalAdaptivePayment' do
      params = {}
      expect(ActiveMerchant::Billing::Integrations::PaypalAdaptivePayment).to receive(:notification).with(params).once.and_return(@success_verify_response)
      response = @gateway.verify_purchase(params)
      expect(response).to be(true)
    end
  end

  describe 'external_id_from_request' do
    it 'returns notification pay_key params' do
      class RequestMock
        def raw_post
          {}
        end
      end
      request = RequestMock.new

      class ResponseMock
        attr_accessor :params
        def initialize
          @params = {'pay_key' => 'key'}
        end
      end

      expect(ActiveMerchant::Billing::Integrations::PaypalAdaptivePayment).to receive(:notification).with(request.raw_post).once.and_return(ResponseMock.new)
      expect(@gateway.external_id_from_request(request)).to eq("key")
    end
  end

  describe 'livemode?' do
    it 'calls livemode? on the gateway' do
      expect(ActiveMerchant::Billing::Base).to receive(:mode).once
      @gateway.livemode?
    end
  end
end
