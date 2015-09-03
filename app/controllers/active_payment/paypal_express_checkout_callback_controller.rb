module ActivePayment
  class PaypalExpressCheckoutCallbackController < ActionController::Base
    protect_from_forgery with: :null_session

    def success
      ActivePayment::Gateway.verify_purchase_from_request(
        gateway: 'paypal_express_checkout',
        request: request,
        data: purchase_params)
      flash[:success] = 'Thank you!'

      redirect_to '/'
    end

    def cancel
      ActivePayment::Gateway.cancel_purchase_from_request(
        gateway: 'paypal_express_checkout', 
        request: request)
      flash[:error] = 'Your transaction has been cancelled'

      redirect_to '/'
    end

    private

    def purchase_params
      {
        ip: request.remote_ip,
        token: params[:token]
      }
    end
  end
end
