require 'rubygems'
require 'spork'
require 'factory_girl'
require 'rake'

Spork.prefork do
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'factory_girl'
  require 'factory_girl_rails'
  require 'capybara/rspec'
  require 'database_cleaner'
  require 'capybara/rails'

  Rails.env ||= 'test'

  SPEC_SUPPORT = File.expand_path(File.join(File.dirname(__FILE__), "support"))
  $: << SPEC_SUPPORT

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.infer_base_class_for_anonymous_controllers = false
    config.color_enabled = true
    config.order = "random"

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = "mongoid"
    end

    config.before(:each) do
      DatabaseCleaner.clean
    end
  end

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

end

Spork.each_run do
  require 'simplecov'
  SimpleCov.start
  require 'factory_girl_rails'

  AngBlog::Application.reload_routes!
  FactoryGirl.reload

  Dir[Rails.root.join("lib/**/*.rb")].each do |f|
    require f
  end

  Dir[Rails.root.join("app/models/*.rb")].each do |f|
    load f
  end
end


