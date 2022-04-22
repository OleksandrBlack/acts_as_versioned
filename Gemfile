# frozen_string_literal: true

source 'http://rubygems.org'

group :development do
  platform :jruby do
    gem 'activerecord-jdbcmysql-adapter'
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'pry'
  end

  gem 'rails', '~>6.1.5'
end

group :test do
  gem 'sqlite3', '~> 1.3.6'
  gem 'test-unit'
end

group :development do
  gem 'rubocop-performance'
  gem 'rubocop-rails'
end
