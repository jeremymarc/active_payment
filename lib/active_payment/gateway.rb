module ActivePayment
  class Gateway
    attr_accessor :gateway, :purchase_token, :transactions

    def initialize(name)
      @transactions = []

      name_str = name.to_s.strip.downcase
      raise(ArgumentError, 'A gateway provider must be specified') if name_str.blank?

      ActiveMerchant::Billing::Base.mode = :test if ActivePayment.configuration.test

      begin
        @gateway = ActivePayment::Gateways.const_get("#{name_str}".camelize).new
      rescue SyntaxError, NameError
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

    def verify_purchase(external_id, remote_ip, raw_data)
      @transactions = ActivePayment::Transaction.where(external_id: external_id)
      fail ActivePayment::NoTransactionError unless @transactions.size > 0
      verify_ip_address(@transactions, remote_ip)

      if raw_data.is_a?(Hash) && raw_data[:amount].blank?
        raw_data[:amount] = @transactions.map(&:amount).inject(0, &:+)
      end

      if @gateway.verify_purchase(raw_data)
        transactions_success(@transactions)
      else
        transactions_error(@transactions)
        fail ActivePayment::InvalidGatewayResponseError
      end
    end

    def cancel_purchase(external_id, remote_ip)
      @transactions = ActivePayment::Transaction.where(external_id: external_id)
      fail ActivePayment::NoTransactionError unless @transactions.size > 0
      verify_ip_address(@transactions, remote_ip)

      transactions_cancel(@transactions)
    end

    def external_id_from_request(request)
      @gateway.external_id_from_request(request)
    end

    def livemode?
      @gateway.livemode?
    end

    def self.verify_purchase_from_request(gateway:, request:, data:)
      payment_gateway = ActivePayment::Gateway.new(gateway)
      external_id = payment_gateway.external_id_from_request(request)
      payment_gateway.verify_purchase(external_id, request.remote_ip, data)
    end

    def self.cancel_purchase_from_request(gateway:, request:)
      payment_gateway = ActivePayment::Gateway.new(gateway)
      external_id = payment_gateway.external_id_from_request(request)
      payment_gateway.cancel_purchase(external_id, request.remote_ip)
    end

    private

    def create_transactions(ip_address)
      fail 'You must called setup_purchase before creating a transaction' unless @gateway.sales

      @gateway.sales.each do |sale|
        @transactions << ActivePayment::Transaction.create({
          currency: 'USD',
          gateway: @gateway.class.to_s,
          amount: sale.amount_in_cents,
          ip_address: ip_address,
          payee_id: sale.payee.id,
          payer_id: sale.payer.id,
          payable_id: sale.payable ? sale.payable.id : nil,
          payable_type: sale.payable ? sale.payable.class.to_s : nil,
          reference_number: sale.payable.reference,
          external_id: @purchase_token,
          metadata: { description: sale.payable.description }
        })
      end
    end

    def verify_ip_address(transactions, remote_ip)
      if ActivePayment.configuration.ip_security
        transactions.each do |transaction|
          fail ActivePayment::SecurityError unless transaction.ip_address == remote_ip
        end
      end
    end

    def transactions_success(transactions)
      transactions.each do |transaction|
        transaction.paid_at = DateTime.now
        transaction.completed!
      end
    end

    def transactions_error(transactions)
      transactions.each do |transaction|
        transaction.error!
      end
    end

    def transactions_cancel(transactions)
      transactions.each do |transaction|
        transaction.canceled!
      end
    end
  end
end
