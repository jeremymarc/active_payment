module ActivePayment
  class Gateway
    attr_accessor :gateway, :purchase_token

    def initialize(name)
      name_str = name.to_s.strip.downcase

      raise(ArgumentError, 'A gateway provider must be specified') if name_str.blank?

      begin
        @gateway = ActivePayment::Gateways.const_get("#{name_str}".camelize).new
      rescue
        raise ArgumentError, "The specified gateway is not valid (#{name_str})"
      end
    end

    def setup_purchase(sales, ip_address)
      amount = sales.amount_in_cents
      raise ActivePayment::InvalidAmountError unless amount >= ActivePayment.configuration.min_amount

      url = @gateway.setup_purchase(sales)
      @purchase_token = @gateway.purchase_token
      create_transactions(ip_address)

      url
    end

    def verify_purchase(external_id, raw_data)
      transactions = ActivePayment::Transaction.where(external_id: external_id)
      fail ActivePayment::NoTransactionError unless transactions.size > 0

      if @gateway.verify_purchase(raw_data)
        transactions_success(transactions)
      else
        transactions_error(transactions)
        fail ActivePayment::InvalidGatewayResponseError
      end
    end

    def external_id_from_request(request)
      @gateway.external_id_from_request(request)
    end

    def livemode?
      @gateway.livemode?
    end

    private

    def total_amount
    end

    def create_transactions(ip_address)
      fail 'You must called setup_purchase before creating a transaction' unless @gateway.sales

      @gateway.sales.each do |sale|
        ActivePayment::Services::TransactionCreate.new({
          currency: "USD",
          gateway: @gateway.class.to_s,
          amount: sale.amount_in_cents,
          ip_address: ip_address,
          payee_id: sale.payee.id,
          payer_id: sale.payer.id,
          payable_id: sale.payable.id,
          reference_number: sale.payable.reference,
          external_id: @purchase_token,
          metadata: { description: sale.payable.description }
        }).call
      end
    end

    def transactions_success(transactions)
      transactions.each do |transaction|
        ActivePayment::Services::TransactionSuccess.new(transaction.id).call
      end
    end

    def transactions_error(transactions)
      transactions.each do |transaction|
        ActivePayment::Services::TransactionError.new(transaction.id).call
      end
    end
  end
end
