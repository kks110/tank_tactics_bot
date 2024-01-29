
require 'active_record'
require 'yaml'
require 'pry'
require_relative './initialise'

namespace :db do
  desc 'Run database migrations'
  task :migrate do
    migrations_path = './db/migrations'
    ActiveRecord::MigrationContext.new(migrations_path, ActiveRecord::Base.connection.schema_migration).migrate
  end
end
