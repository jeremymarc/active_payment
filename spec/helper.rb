ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
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
