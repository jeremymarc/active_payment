require 'helper'

describe ActivePayment::Models::Sale do
  before(:each) do
    class Payee
      include ActivePayment::Models::Payee

      def paypal_identifier
        "test@paypal.com"
      end
    end
    class Payer
      include ActivePayment::Models::Payer
    end
    class Payable
      include ActivePayment::Models::Payable

      def amount
        100
      end

      def description
        "description"
      end

      def tax
        10
      end

      def shipping
        20
      end
    end

    @payer = Payer.new
    @payee = Payee.new
    @payable = Payable.new
    @sale = ActivePayment::Models::Sale.new(@payable, @payer, @payee)
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
      expect(@sale.description).to eq(@payable.description)
    end
  end

  describe 'shipping' do
    it 'displays the payable shipping value' do
      expect(@sale.shipping).to eq(@payable.shipping)
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
        email: @payee.paypal_identifier,
        amount: 1,
        primary: false
      })
    end
  end

  describe 'paypal_hash' do
    it 'displays the paypal_hash with correct values' do
      expect(@sale.paypal_hash).to eq({
        description: @payable.description,
        invoice_data: {
          item: [{
            name: @payable.description,
            item_count: 1,
            item_price: 1,
            price: 1
          }],
          total_shipping: @payable.shipping,
          total_tax: @payable.tax
        },
        receiver: {
          email: @payee.paypal_identifier
        }
      })
    end
  end
end
