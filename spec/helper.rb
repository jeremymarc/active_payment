ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'shoulda/matchers'
require 'factory_girl_rails'

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

class ActionView::TestCase::TestController
  def default_url_options(options={})
    { :host => 'localhost' }.merge(options)
  end
end

class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    { :host => 'localhost' }.merge(options)
  end
end

class PayeeObj
  attr_accessor :paypal

  def id
    1
  end

  def paypal
    'activepayment@paypal.com'
  end

  def to_payee
    ActivePayment::Models::Payee.new(id: id, paypal_identifier: paypal)
  end
end
class PayerObj
  def id
    2
  end
end

class PayableObj
  def id
    3
  end

  def amount
    100
  end

  def description
    'description'
  end

  def tax
    10
  end

  def shipping
    20
  end

  def to_payable
    ActivePayment::Models::Payable.new(
      id: id,
      class: self.class,
      amount: amount,
      description: description,
      reference_number: id,
      tax: tax,
      shipping: shipping)
  end
end

RSpec.configure do |config|
  config.order = 'random'
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
  FactoryGirl.find_definitions

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
