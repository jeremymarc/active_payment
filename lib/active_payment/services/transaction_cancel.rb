module ActivePayment
  module Services
    class TransactionCancel
      def initialize(transaction_id)
        @transaction_id = transaction_id
      end

      def call
        transaction = ActivePayment::Transaction.find(@transaction_id)
        transaction.state = Transaction.states[:canceled]
        transaction.save!
      end
    end
  end
end
