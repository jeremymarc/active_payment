module ActivePayment
  module Services
    class TransactionCreate
      def initialize(params = {})
        @params = params
      end

      def call
        transaction = ActivePayment::Transaction.new(@params)
        transaction.state = ActivePayment::Transaction.states[:pending]
        transaction.save!
      end
    end
  end
end
