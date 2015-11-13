require 'helper'

describe ActivePayment::Models::Sales do
  before(:each) do
    @payer = PayerObj.new
    @payee = PayeeObj.new
    @payable = PayableObj.new.to_payable
    @sale = ActivePayment::Models::Sale.new(payable: @payable, payer: @payer, payee: @payee)
    @sale2 = ActivePayment::Models::Sale.new(payable: @payable, payer: @payer, payee: @payee)
    @sale3 = ActivePayment::Models::Sale.new(payable: @payable, payer: @payer, payee: @payee)

    @sales = ActivePayment::Models::Sales.new([@sale, @sale2, @sale3])
  end

  describe 'initialize' do
    it 'initialize correct value' do
      expect(@sales.sales.count).to eq(@sales.count)
    end

    it 'should allow initialization with no parameters' do
      expect(ActivePayment::Models::Sales.new.sales).to eq([])
    end
  end

  describe 'amount' do
    it 'displays the sum of sales amount' do
      expect(@sales.amount).to eq(3)
    end
  end

  describe 'amount_in_cents' do
    it 'displays the sum of sales amount in cents' do
      expect(@sales.amount_in_cents).to eq(300)
    end
  end

  describe 'total_shipping' do
    it 'displays the sum of total_shipping' do
      expect(@sales.total_shipping).to eq(60)
    end
  end

  describe 'total_tax' do
    it 'displays the sum of total_tax' do
      expect(@sales.total_tax).to eq(30)
    end
  end

  describe 'paypal_hash' do
    it 'display an array of sale paypal_hash' do
    end
  end

  describe 'each' do
    it 'behave as expected' do
    end
  end

  describe 'paypal_recipients' do
    it 'display an array of sale paypal_recipient' do
    end
  end
end
