module ActivePayment
  class PaypalAdaptivePaymentCallbackController < ActionController::Base
    protect_from_forgery with: :null_session

    def ipn
      payment_gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
      external_id = payment_gateway.external_id_from_request(request)
      payment_gateway.verify_purchase(external_id, request.remote_ip, request.raw_post)

      head :ok
    end

    def success
      flash[:success] = 'Thank you!'
      redirect_to '/'
    end

    def cancel
      payment_gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
      external_id = payment_gateway.external_id_from_request(request)
      payment_gateway.cancel_purchase(external_id, request.remote_ip)

      flash[:error] = 'Your transaction has been canceled'
      redirect_to '/'
    end
  end
end
