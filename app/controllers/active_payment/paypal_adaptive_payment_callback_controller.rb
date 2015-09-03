module ActivePayment
  class PaypalAdaptivePaymentCallbackController < ActionController::Base
    protect_from_forgery with: :null_session

    def success
      flash[:success] = 'Thank you!'
      redirect_to '/'
    end

    def cancel
      ActivePayment::Gateway.cancel_purchase_from_request(
        gateway: 'paypal_adaptive_payment',
        request: request)
      flash[:error] = 'Your transaction has been canceled'
      redirect_to '/'
    end

    def ipn
      ActivePayment::Gateway.verify_purchase_from_request(
        gateway: 'paypal_adaptive_payment',
        request: request,
        data: request.raw_post)
      head :ok
    end
  end
end
