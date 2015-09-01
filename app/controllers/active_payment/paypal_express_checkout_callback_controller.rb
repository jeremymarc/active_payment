module ActivePayment
  class PaypalExpressCheckoutCallbackController < ActionController::Base
    protect_from_forgery with: :null_session

    def success
      payment_gateway = ActivePayment::Gateway.new('paypal_express_checkout')
      external_id = payment_gateway.external_id_from_request(request)
      payment_gateway.verify_purchase(external_id, request.remote_ip, purchase_params)
      flash[:success] = 'Thank you!'

      redirect_to '/'
    end

    def cancel
      payment_gateway = ActivePayment::Gateway.new('paypal_express_checkout')
      external_id = payment_gateway.external_id_from_request(request)
      payment_gateway.cancel_purchase(external_id, request.remote_ip)

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
