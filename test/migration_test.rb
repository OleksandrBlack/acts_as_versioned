# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'abstract_unit')
require 'minitest/autorun'

if ActiveRecord::Base.connection.supports_migrations?
  class Thing < ApplicationRecord
    attr_accessor :version

    acts_as_versioned
  end

  class MigrationTest < ActiveSupport::TestCase
    self.use_transactional_tests = false
    def teardown
      if ActiveRecord::Base.connection.respond_to?(:initialize_schema_information)
        ActiveRecord::Base.connection.initialize_schema_information
        ActiveRecord::Base.connection.update 'UPDATE schema_info SET version = 0'
      else
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
      ActiveRecord::Migrator.down("#{File.dirname(__FILE__)}/fixtures/migrations/")
      assert_raises(ActiveRecord::StatementInvalid) { Thing.create title: 'blah blah' }
      # take 'er up
      ActiveRecord::Migrator.up("#{File.dirname(__FILE__)}/fixtures/migrations/")
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
      ActiveRecord::Migrator.down("#{File.dirname(__FILE__)}/fixtures/migrations/")
      assert_raises(ActiveRecord::StatementInvalid) { Thing.create title: 'blah blah' }
    end
  end
end
