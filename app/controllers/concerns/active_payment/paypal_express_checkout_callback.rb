module ActivePayment
  module PaypalExpressCheckoutCallback
    extend ActiveSupport::Concern

    included do
      before_action :transaction_from_params
    end

    def success
      begin
        payment_gateway = ActivePayment::Gateway.new('paypal_express_checkout')
        external_id = payment_gateway.external_id_from_request(request)
        payment_gateway.verify_purchase(external_id, purchase_params)
        flash[:success] = "Thank you!"
      rescue
        flash[:error] = "Sorry! Something went wrong with the Paypal purchase. Our transaction has been canceled"
      end

      redirect_to '/'
    end

    def cancel
      transactions_error
      flash[:error] = "Your transaction has been canceled"

      redirect_to '/'
    end

    private

    def transaction_from_params
      redirect_to '/' and return if params[:token].nil?
      @transactions = ActivePayment::Transaction.where(external_id: params[:token])
      fail ActiveRecord::RecordNotFound unless @transactions.size > 0

      @transactions.each do |transaction|
        fail SecurityError unless transaction.pending?

        if ActivePayment.configuration.ip_security
          fail SecurityError unless transaction.ip_address == request.remote_ip
        end
      end
    end

    def transactions_error
      @transactions.each do |transaction|
        ActivePayment::Services::TransactionCancel.new(transaction.id).call
      end
    end

    def transactions_amount
      amount = 0
      @transactions.each do |transaction|
        amount += transaction.amount
      end

      amount
    end

    def purchase_params
      {
        ip: request.remote_ip,
        token: params[:token],
        amount: transactions_amount
      }
    end
  end
end
