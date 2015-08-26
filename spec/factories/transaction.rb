FactoryGirl.define do
  factory :transaction, :class => 'ActivePayment::Transaction' do
    amount 123
    currency "usd"
    reference_number "1234"
    external_id "5678"
    payee_id 1
    payer_id 1
    payable_id 1
    gateway "paypal_express_checkout"
    state "pending"
    ip_address "127.0.0.1"
    source nil
  end
end
