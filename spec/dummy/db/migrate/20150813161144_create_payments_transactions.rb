class CreatePaymentsTransactions < ActiveRecord::Migration
  def change
    create_table :active_payment_transactions do |t|
      t.integer :amount
      t.string :currency
      t.string :reference_number
      t.string :external_id
      t.integer :payee_id
      t.integer :payer_id
      t.integer :payable_id
      t.string :gateway
      t.integer :source
      t.integer :state
      t.text :metadata
      t.string :ip_address
      t.datetime :paid_at, default: nil

      t.timestamps
    end
  end
end
