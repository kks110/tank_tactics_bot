
require 'dotenv/load'
require 'yaml'
require 'active_record'

db_config_file = File.open('./config/database.yml', aliases: true)
db_config = YAML.safe_load(db_config_file)[ENV.fetch('ENVIRONMENT', 'dev')]

ActiveRecord::Base.establish_connection(db_config)
