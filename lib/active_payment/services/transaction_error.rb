module ActivePayment
  module Services
    class TransactionError
      def initialize(transaction_id)
        @transaction_id = transaction_id
      end

      def call
        transaction = ActivePayment::Transaction.find(@transaction_id)
        transaction.state = Transaction.states[:error]
        transaction.save!
      end
    end
  end
end
