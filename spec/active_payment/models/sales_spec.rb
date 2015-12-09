require 'helper'

describe ActivePayment::Models::Sales do
  before(:each) do
    @payer = PayerObj.new
    @payee = PayeeObj.new.to_payee
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
      expect(@sales.paypal_hash).to eq([{:description=>"description", :invoice_data=>{:item=>[{:name=>"description", :item_count=>1, :item_price=>1.0, :price=>1.0}], :total_shipping=>20, :total_tax=>10}, :receiver=>{:email=>"activepayment@paypal.com"}}, {:description=>"description", :invoice_data=>{:item=>[{:name=>"description", :item_count=>1, :item_price=>1.0, :price=>1.0}], :total_shipping=>20, :total_tax=>10}, :receiver=>{:email=>"activepayment@paypal.com"}}, {:description=>"description", :invoice_data=>{:item=>[{:name=>"description", :item_count=>1, :item_price=>1.0, :price=>1.0}], :total_shipping=>20, :total_tax=>10}, :receiver=>{:email=>"activepayment@paypal.com"}}])
    end
  end

  describe 'paypal_recipients' do
    it 'display an array of sale paypal_recipient' do
      expect(@sales.paypal_recipients).to eq([{:email=>"activepayment@paypal.com", :amount=>1.0, :primary=>false}, {:email=>"activepayment@paypal.com", :amount=>1.0, :primary=>false}, {:email=>"activepayment@paypal.com", :amount=>1.0, :primary=>false}])
    end

    it 'display only recipient with amount > 0' do
      ActivePayment::Models::Sale.any_instance.stub(:amount).and_return(0)
      expect(@sales.paypal_recipients).to eq([])
    end
  end
end
