class DatabaseTestController < ApplicationController
  def index
    @tables = test_database_connection
  end

  private

  def test_database_connection
    ActiveRecord::Base.connection.execute("SHOW TABLES").to_a
  rescue => e
    ["Error: #{e.message}"]
  end
end