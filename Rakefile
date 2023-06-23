
require 'active_record'

namespace :db do
  task :connect do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'test.db'
    )
  end
end

namespace :migrate do
  desc 'Run the test database migrations'
  task :up => :'db:connect' do
    migrations = ActiveRecord::Migration.new.migration_context.migrations
    ActiveRecord::Migrator.new(:up, migrations, nil).migrate
  end

  desc 'Reverse the test database migrations'
  task :down => :'db:connect' do
    migrations = ActiveRecord::Migration.new.migration_context.migrations
    ActiveRecord::Migrator.new(:down, migrations, nil).migrate
  end
end