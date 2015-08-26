require 'helper'

describe ActivePayment::Services::TransactionCreate do
  describe '#call' do
    it 'create a new transaction' do
      expect_any_instance_of(ActivePayment::Transaction).to receive(:state=).with(ActivePayment::Transaction.states[:pending])
      expect_any_instance_of(ActivePayment::Transaction).to receive(:save!)

      ActivePayment::Services::TransactionCreate.new({}).call
    end
  end
end
