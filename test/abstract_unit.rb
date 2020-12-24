# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :development)

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")
require 'test/unit'
require 'active_support'
require 'active_record'
require 'active_record/fixtures'

begin
  require 'byebug'
  Debugger.start
rescue LoadError
end

# require 'simplecov'
# SimpleCov.start 'rails'

require 'acts_as_versioned'

config = YAML.safe_load(IO.read("#{File.dirname(__FILE__)}/database.yml"))
ActiveRecord::Base.logger = Logger.new("#{File.dirname(__FILE__)}/debug.log")
ActiveRecord::Base.configurations = { 'test' => config[ENV['DB'] || 'sqlite3'] }
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])

load("#{File.dirname(__FILE__)}/schema.rb")

# set up custom sequence on widget_versions for DBs that support sequences
if ENV['DB'] == 'postgresql'
  begin
    ActiveRecord::Base.connection.execute 'DROP SEQUENCE widgets_seq;'
  rescue StandardError
    nil
  end
  ActiveRecord::Base.connection.remove_column :widget_versions, :id
  ActiveRecord::Base.connection.execute 'CREATE SEQUENCE widgets_seq START 101;'
  ActiveRecord::Base.connection.execute "ALTER TABLE widget_versions ADD COLUMN id INTEGER PRIMARY KEY DEFAULT nextval('widgets_seq');"
end

module ActiveSupport
  class TestCase #:nodoc:
    include ActiveRecord::TestFixtures

    self.fixture_path = "#{File.dirname(__FILE__)}/fixtures/"

    # Turn off transactional fixtures if you're working with MyISAM tables in MySQL
    self.use_transactional_tests = true

    # Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
    self.use_transactional_tests = false

    # Add more helper methods to be used by all tests here...
  end
end

unless defined?(ApplicationRecord)
  ApplicationRecord = Class.new(ActiveRecord::Base)
  ApplicationRecord.abstract_class = true
end

$LOAD_PATH.unshift(ActiveSupport::TestCase.fixture_path)
