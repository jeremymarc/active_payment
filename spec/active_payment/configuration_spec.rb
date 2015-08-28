require 'helper'

describe ActivePayment::Configuration do
  before(:each) do
    @configuration = ActivePayment::Configuration.new
  end

  it 'set the min amount' do
    @configuration.min_amount = 10
    expect(@configuration.min_amount).to eq(10)
  end

  it 'set the min amount when its not set' do
    expect(@configuration.min_amount).to eq(0)
  end

  it 'set the ip_security to false by default' do
    expect(@configuration.ip_security).to eq(false)
  end

  it 'set the ip_security' do
    @configuration.ip_security = true
    expect(@configuration.ip_security).to eq(true)
  end

  it 'set paypal login' do
    @configuration.paypal_login = 'login@paypal.com'
    expect(@configuration.paypal_login).to eq('login@paypal.com')
  end

  it 'set paypal password' do
    @configuration.paypal_password = 'password'
    expect(@configuration.paypal_password).to eq('password')
  end

  it 'set paypal signature' do
    @configuration.paypal_signature = 'signature'
    expect(@configuration.paypal_signature).to eq('signature')
  end

  it 'set paypal appid' do
    @configuration.paypal_appid = 'appid'
    expect(@configuration.paypal_appid).to eq('appid')
  end

  it 'set the paypal adaptive payment callback controller by default' do
    expect(@configuration.paypal_adaptive_payment_callback_controller).to eq('active_payment/paypal_adaptive_payment_callback')
  end

  it 'set the paypal adaptive payment callback controller' do
    @configuration.paypal_adaptive_payment_callback_controller = 'test'
    expect(@configuration.paypal_adaptive_payment_callback_controller).to eq('test')
  end

  it 'set the paypal adaptive payment callback controller by default' do
    expect(@configuration.paypal_express_checkout_callback_controller).to eq('active_payment/paypal_express_checkout_callback')
  end

  it 'set the paypal adaptive payment callback controller' do
    @configuration.paypal_express_checkout_callback_controller = 'test'
    expect(@configuration.paypal_express_checkout_callback_controller).to eq('test')
  end
end
