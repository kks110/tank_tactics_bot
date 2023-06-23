
require 'active_record'
require 'yaml'
require 'pry'

# Load database configuration from YAML file
db_config = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(db_config)

namespace :db do
  desc 'Run database migrations'
  task :migrate do
    ActiveRecord::MigrationContext.new('./db/migrations', ActiveRecord::SchemaMigration).migrate
  end
end