module ActivePayment
  class Transaction < ActiveRecord::Base
    enum state: [:pending, :completed, :canceled, :error]
    serialize :metadata

    validates :amount, :currency, :external_id, :ip_address,
      :payee_id, :payer_id, :gateway, :state, presence: true

    # in cents
    validates :amount, numericality: { only_integer: true, greater_than: 0 }

    after_initialize do
      if self.new_record?
        self.state ||= Transaction.states[:pending]
      end
    end
  end
end
