require 'helper'

describe ActivePayment::Services::TransactionSuccess do
  describe '#call' do
    it 'update transaction state' do
      transaction = create(:transaction)
      expect(ActivePayment::Transaction).to receive(:find).with(transaction.id).and_return(transaction)
      expect_any_instance_of(ActivePayment::Transaction).to receive(:state=).with(ActivePayment::Transaction.states[:completed])
      expect_any_instance_of(ActivePayment::Transaction).to receive(:save!)

      ActivePayment::Services::TransactionSuccess.new(transaction.id).call
    end
  end
end
