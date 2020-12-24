# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'abstract_unit')
require 'minitest/autorun'

class Thing < ApplicationRecord
  attr_accessor :version

  acts_as_versioned
end

class MigrationTest < ActiveSupport::TestCase
  MIGRATIONS_PATH = "#{File.dirname(__FILE__)}/fixtures/migrations/"

  def migrate(direction)
    if defined?(ActiveRecord::MigrationContext)
      @migrator ||= ActiveRecord::MigrationContext.new(MIGRATIONS_PATH, ActiveRecord::SchemaMigration)
      @migrator.send(direction)
    else
      ActiveRecord::Migrator.send(direction, MIGRATIONS_PATH)
    end
  end

  self.use_transactional_tests = false
  def teardown
    if ActiveRecord::Base.connection.respond_to?(:initialize_schema_information)
      ActiveRecord::Base.connection.initialize_schema_information
      ActiveRecord::Base.connection.update 'UPDATE schema_info SET version = 0'
    elsif ActiveRecord::Base.connection.respond_to?(:initialize_schema_migrations_table)
      ActiveRecord::Base.connection.initialize_schema_migrations_table
      ActiveRecord::Base.connection.assume_migrated_upto_version(0, "#{File.dirname(__FILE__)}/fixtures/migrations/")
    end

    begin
      Thing.connection.drop_table 'things'
    rescue StandardError
      nil
    end
    begin
      Thing.connection.drop_table 'thing_versions'
    rescue StandardError
      nil
    end
  end

  def test_versioned_migration
    migrate(:down)
    assert_raises(ActiveRecord::StatementInvalid) { Thing.create title: 'blah blah' }
    # take 'er up
    migrate(:up)
    t = Thing.create title: 'blah blah', price: 123.45, type: 'Thing'
    assert_equal 1, t.versions.size

    # check that the price column has remembered its value correctly
    assert_equal t.price,  t.versions.first.price
    assert_equal t.title,  t.versions.first.title
    assert_equal t[:type], t.versions.first[:versioned_type]

    # make sure that the precision of the price column has been preserved
    assert_equal 7, Thing::Version.columns.find { |c| c.name == 'price' }.precision
    assert_equal 2, Thing::Version.columns.find { |c| c.name == 'price' }.scale

    # now lets take 'er back down
    migrate(:down)
    assert_raises(ActiveRecord::StatementInvalid) { Thing.create title: 'blah blah' }
  end
end
