
require 'dotenv/load'
require 'yaml'
require 'active_record'

binding.pry
env = [ENV.fetch('ENVIRONMENT', 'dev')]

db_config_file = File.open('./config/database.yml')
db_config = YAML.safe_load(db_config_file)[env]

db_config.merge!('url' => ENV.fetch('TT_DATABASE_URL', nil)) if env == 'prod'

ActiveRecord::Base.establish_connection(db_config)
