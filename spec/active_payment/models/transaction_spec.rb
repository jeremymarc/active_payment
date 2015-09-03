require 'helper'

describe ActivePayment::Transaction do
  before { @transaction = create(:transaction) }

  subject { @transaction }

  it { should be_valid }
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:external_id) }
  it { should validate_presence_of(:payee_id) }
  it { should validate_presence_of(:payer_id) }
  it { should validate_presence_of(:gateway) }
  it { should validate_presence_of(:state) }

  it { should_not allow_value('0').for(:amount) }
  it { should_not allow_value('-1').for(:amount) }
  it { should_not allow_value('a').for(:amount) }
  it { should allow_value('100').for(:amount) }

  it { should allow_value('usd').for(:currency) }
  it { should allow_value('paypal').for(:gateway) }
  it { should allow_value('completed').for(:state) }
  it { should allow_value('pending').for(:state) }
  it { should allow_value('canceled').for(:state) }
  it { should allow_value('error').for(:state) }
  it { should allow_value('127.0.0.1').for(:ip_address) }

  it { should allow_value(DateTime.now).for(:paid_at) }
end
