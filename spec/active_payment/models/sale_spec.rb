require 'helper'

describe ActivePayment::Models::Sale do
  before(:each) do
    @payer = PayerObj.new
    # @payer = payer_obj.to_payer
    payee_obj = PayeeObj.new
    @payee = payee_obj.to_payee
    payable_obj = PayableObj.new
    @payable = payable_obj.to_payable
    @sale = ActivePayment::Models::Sale.new(payable: @payable, payer: @payer, payee: @payee)
  end

  describe 'initialize' do
    it 'initialize with correct values' do
      expect(@sale.payable).to eq(@payable)
      expect(@sale.payer).to eq(@payer)
      expect(@sale.payee).to eq(@payee)
    end
  end

  describe 'amount' do
    it 'displays amount in $' do
      expect(@sale.amount).to eq(1)
    end
  end

  describe 'amount_in_cents' do
    it 'displays amount in cents' do
      expect(@sale.amount_in_cents).to eq(100)
    end
  end

  describe 'description' do
    it 'displays the payable description' do
      expect(@sale.description).to eq(@sale.payable.description)
    end
  end

  describe 'shipping' do
    it 'displays the payable shipping value' do
      expect(@sale.shipping).to eq(@sale.payable.shipping)
    end
  end

  describe 'tax' do
    it 'displays the payable tax value' do
      expect(@sale.tax).to eq(@payable.tax)
    end
  end

  describe 'paypal_recipient' do
    it 'displays the paypal_recipient hash with correct values' do
      expect(@sale.paypal_recipient).to eq({
        email: @sale.payee.identifier,
        amount: 1,
        primary: false
      })
    end
  end

  describe 'paypal_hash' do
    it 'displays the paypal_hash with correct values' do
      expect(@sale.paypal_hash).to eq({
        description: @sale.payable.description,
        invoice_data: {
          item: [{
            name: @sale.payable.description,
            item_count: 1,
            item_price: 1,
            price: 1
          }],
          total_shipping: @sale.payable.shipping,
          total_tax: @sale.payable.tax
        },
        receiver: {
          email: @sale.payee.identifier
        }
      })
    end
  end
end
