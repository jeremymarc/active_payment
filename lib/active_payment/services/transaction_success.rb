module ActivePayment
  module Services
    class TransactionSuccess
      def initialize(transaction_id)
        @transaction_id = transaction_id
      end

      def call
        transaction = Transaction.find(@transaction_id)
        transaction.state = Transaction.states[:completed]
        # transaction.paid_at = DateTime.now
        transaction.save!
      end
    end
  end
end
