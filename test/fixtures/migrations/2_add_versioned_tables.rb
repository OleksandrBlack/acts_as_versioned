# frozen_string_literal: true

class AddVersionedTables < ActiveRecord::Migration[5.0]
  def self.up
    create_table('things') do |t|
      t.column :title, :text
      t.column :price, :decimal, precision: 7, scale: 2
      t.column :type, :string
    end
    Thing.create_versioned_table
  end

  def self.down
    Thing.drop_versioned_table
    begin
      drop_table 'things'
    rescue StandardError
      nil
    end
  end
end
