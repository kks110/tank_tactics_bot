
require 'active_record'
require 'yaml'
require 'pry'
require_relative './initialise'

namespace :db do
  desc 'Run database migrations'
  task :migrate do
    ActiveRecord::MigrationContext.new('./db/migrations', ActiveRecord::SchemaMigration).migrate
  end
end