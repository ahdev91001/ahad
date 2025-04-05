#!/usr/bin/env ruby
# Save as generate_migrations_from_schema.rb
# Run with: `rails runner generate_migrations_from_schema.rb`

require 'active_record'
require 'rails/generators'
require 'rails/generators/active_record/migration/migration_generator'
require 'fileutils'

# Ensure db/migrate directory exists
migrate_dir = File.join(Rails.root, 'db', 'migrate')
FileUtils.mkdir_p(migrate_dir)

schema_path = File.join(Rails.root, 'db', 'schema.rb')

unless File.exist?(schema_path)
  puts "schema.rb not found at #{schema_path}"
  exit 1
end

puts "Parsing schema.rb..."

schema = File.read(schema_path)
tables = schema.scan(/create_table\s+"(\w+)",.*?do\s+\|t\|(.+?)end/m)

if tables.empty?
  puts "No tables found in schema.rb"
  exit 1
end

timestamp = Time.now

tables.each_with_index do |(table_name, body), i|
  class_name = "Create#{table_name.camelize}"
  filename = File.join(migrate_dir, "#{(timestamp + i).utc.strftime('%Y%m%d%H%M%S')}_create_#{table_name}.rb")
  puts "Generating migration for table: #{table_name}"

  columns = body.scan(/t\.(\w+)\s+"(\w+)"(?:,\s+limit:\s*(\d+))?(?:,\s+null:\s*(\w+))?/)

  migration = <<~RUBY
    class #{class_name} < ActiveRecord::Migration[7.1]
      def change
        create_table :#{table_name} do |t|
  RUBY

  columns.each do |type, name, limit, nullable|
    opts = []
    opts << "limit: #{limit}" if limit
    opts << "null: #{nullable}" if nullable
    migration += "      t.#{type} :#{name}"
    migration += ", #{opts.join(', ')}" unless opts.empty?
    migration += "\n"
  end

  migration += "    end\n"
  migration += "  end\nend\n"

  File.write(filename, migration)
  puts "  ➤ Created: #{filename}"
end

puts "\n✅ Done! Now run `rails db:migrate` to apply the new migrations."
