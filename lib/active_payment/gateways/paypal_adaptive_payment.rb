require 'active_merchant'

module ActivePayment
  module Gateways
    class PaypalAdaptivePayment
      include ActionView::Helpers
      include ActionDispatch::Routing
      # include Rails.application.routes.url_helpers

      attr_accessor :purchase_token, :sales

      def initialize
        @gateway = ActiveMerchant::Billing::PaypalAdaptivePayment.new(paypal_options)
      end

      def setup_purchase(sales)
        @sales = sales

        response = @gateway.setup_purchase(purchase_data(sales))
        raise ActivePayment::InvalidGatewayResponseError unless response.success?

        @purchase_token = response['payKey']
        @gateway.set_payment_options(payment_options_data(@purchase_token, @sales))
        @gateway.redirect_url_for(response['payKey'])
      end

      # return boolean
      def verify_purchase(params)
        notify = ActiveMerchant::Billing::Integrations::PaypalAdaptivePayment.notification(params)

        notify.acknowledge && notify.complete?
      end

      def livemode?
        ActiveMerchant::Billing::Base.mode != :test
      end

      def external_id_from_request(request)
        notify = ActiveMerchant::Billing::Integrations::PaypalAdaptivePayment.notification(request.raw_post)

        notify.params['pay_key']
      end

      private

      def paypal_options
        {
          action_type: "CREATE",
          login: ActivePayment.configuration.paypal_login,
          password: ActivePayment.configuration.paypal_password,
          signature: ActivePayment.configuration.paypal_signature,
          appid: ActivePayment.configuration.paypal_appid
        }
      end

      def purchase_data(sales)
        {
          return_url: return_url,
          cancel_url: cancel_return_url,
          ipn_notification_url: ipn_notification_url,
          receiver_list: sales.paypal_recipients,
        }
      end

      def payment_options_data(key, sales)
        {
          pa_key: key,
          receiver_options: sales.paypal_hash,
        }
      end

      def return_url
        "http://7e2c49d1.ngrok.io/payments/paypal_adaptive/success"
        # url_for(controller: 'payments/paypal_adaptive_payment_callback', action: :success, only_path: false)
      end

      def cancel_return_url
        "http://7e2c49d1.ngrok.io/payments/paypal_adaptive/cancel"
        # url_for(controller: 'payments/paypal_adaptive_payment_callback', action: :cancel, only_path: false)
      end

      def ipn_notification_url
        "http://7e2c49d1.ngrok.io/payments/paypal_adaptive/ipn"
      end
    end
  end
end
