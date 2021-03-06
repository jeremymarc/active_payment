require 'helper'

describe ActivePayment::Gateways::PaypalExpressCheckout do
  before(:each) do
    @payer = PayerObj.new
    @payee = PayeeObj.new
    @payable = PayableObj.new
    @sale = ActivePayment::Models::Sale.new(payable: @payable.to_payable, payer: @payer, payee: @payee)
    @payee2 = PayeeObj.new
    @payee2.paypal = 'test2@paypal.com'
    @payee3 = PayeeObj.new
    @payee3.paypal = 'test3@paypal.com'
    @sale2 = ActivePayment::Models::Sale.new(payable: @payable.to_payable, payer: @payer, payee: @payee2.to_payee)
    @sale3 = ActivePayment::Models::Sale.new(payable: @payable.to_payable, payer: @payer, payee: @payee3.to_payee)

    @sales = ActivePayment::Models::Sales.new([@sale, @sale2, @sale3])
    @gateway = ActivePayment::Gateways::PaypalExpressCheckout.new
    class SuccessMockResponse
      def success?
        true
      end

      def payer_id
        1
      end

      def token
        "token"
      end
    end
    class FailedMockResponse
      def success?
        false
      end

      def payer_id
        1
      end

      def token
        "token"
      end
    end
    @success_gateway_response = SuccessMockResponse.new
    @failed_gateway_response = FailedMockResponse.new
  end

  describe 'initialize' do
    it 'initialize the correct gateway' do
      expect(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:new).once
      ActivePayment::Gateways::PaypalExpressCheckout.new
    end
  end

  describe 'setup_purchase' do
    it 'call setup_purchase on the gateway' do
      expect_any_instance_of(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:setup_purchase).once.and_return(@success_gateway_response)
      @gateway.setup_purchase(@sales)
    end

    it 'raise InvalidGatewayResponse if response is not success' do
      expect {
        expect_any_instance_of(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:setup_purchase).once.and_return(@failed_gateway_response)
        @gateway.setup_purchase(@sales)
      }.to raise_error(ActivePayment::InvalidGatewayResponseError)
    end
  end

  describe 'verify_purchase' do
    it 'calls notification on PaypalAdaptivePayment' do
      params = {:token => 'token', :amount => 100}
      expect_any_instance_of(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:details_for).with('token').once.and_return(@success_gateway_response)
      expect_any_instance_of(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:purchase).once.and_return(@success_gateway_response)
      @gateway.verify_purchase(params)
    end

    it 'returns false is response if a failure' do
      params = {:token => 'token', :amount => 100}
      expect_any_instance_of(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:details_for).with('token').once.and_return(@failed_gateway_response)
      response = @gateway.verify_purchase(params)
      expect(response).to be(false)
    end

    it 'returns true if response is success' do
      params = {:token => 'token', :amount => 100}
      expect_any_instance_of(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:details_for).with('token').once.and_return(@success_gateway_response)
      expect_any_instance_of(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:purchase).once.and_return(@success_gateway_response)
      response = @gateway.verify_purchase(params)
      expect(response).to be(true)
    end
  end

  describe 'external_id_from_request' do
    it 'return the param token' do
      class Request
        attr_accessor :params
        def initialize
          @params = {:token => 'key'}
        end
      end

      response = @gateway.external_id_from_request(Request.new)
      expect(response).to eq('key')
    end
  end

  describe 'livemode?' do
    it 'calls livemode? on the gateway' do
      expect(ActiveMerchant::Billing::Base).to receive(:mode).once
      @gateway.livemode?
    end
  end
end
