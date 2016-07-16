require 'active_merchant'

module ActivePayment
  module Gateways
    class PaypalExpressCheckout
      include ActionView::Helpers
      include ActionDispatch::Routing
      include ActivePayment::Engine.routes.url_helpers

      attr_accessor :purchase_token, :sales

      def initialize
        @gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
      end

      def setup_purchase(sales)
        @sales = sales

        payables = @sales.map(&:payable)
        amount = @sales.amount_in_cents.to_i

        response = @gateway.setup_purchase(amount, paypal_data(payables))
        raise ActivePayment::InvalidGatewayResponseError.new(response) unless response.success?

        @purchase_token = response.token
        @gateway.redirect_url_for(response.token)
      end

      # return boolean
      def verify_purchase(params)
        token = params[:token]

        begin
          response = @gateway.details_for(token)
          fail ActivePayment::InvalidGatewayResponseError.new(response) unless response.success?

          amount = params[:amount]
          purchase_response = @gateway.purchase(amount, params.merge(payer_id: response.payer_id))
          fail ActivePayment::InvalidGatewayResponseError.new(purchase_response) unless purchase_response.success?
        rescue ActivePayment::InvalidGatewayResponseError
          return false
        end

        true
      end

      def external_id_from_request(request)
        request.params[:token]
      end

      def livemode?
        ActiveMerchant::Billing::Base.mode != :test
      end

      private

      def paypal_options
        {
          login: ActivePayment.configuration.paypal_login,
          password: ActivePayment.configuration.paypal_password,
          signature: ActivePayment.configuration.paypal_signature,
        }
      end

      def paypal_data(payables)
        {
          items: payables.map(&:to_paypal_hash),
          return_url: return_url,
          cancel_return_url: cancel_return_url,
          currency: @sales.currency,
          allow_note: false,
          allow_guest_checkout: true
        }
      end

      def return_url
        url_for(controller: 'active_payment/paypal_express_checkout_callback', action: :success, only_path: false, host: ActivePayment.configuration.default_url_host)
      end

      def cancel_return_url
        url_for(controller: 'active_payment/paypal_express_checkout_callback', action: :cancel, only_path: false, host: ActivePayment.configuration.default_url_host)
      end
    end

  end
end
