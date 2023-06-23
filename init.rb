# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'
require './register_commands'
require 'pry'
require 'active_record'
require './models/player'

# TODO: Use Postgres
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'test.db'
)

ActiveRecord::Schema.define do
  create_table :players do |t|
    t.integer :discord_id
    t.text :user_name
  end
end
catch SQLite3::SQLException

Player.create(discord_id: 123, user_name: 'kks110')

bot = Discordrb::Bot.new(token: ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil), intents: [:server_messages])

RegisterCommands.run(bot: bot)

bot.application_command(:draw_board) do |event|
  board = "```
  ╭──────┬──────┬──────┬──────┬──────╮
  │1  3HP│      │      │      │      │
  │ Adam │      │      │      │      │
  ├──────┼──────┼──────┼──────┼──────┤
  │      │      │      │      │      │
  │      │      │      │      │      │
  ├──────┼──────┼──────┼──────┼──────┤
  │      │      │      │      │      │
  │      │      │      │      │      │
  ├──────┼──────┼──────┼──────┼──────┤
  │      │      │      │      │      │
  │      │      │      │      │      │
  ├──────┼──────┼──────┼──────┼──────┤
  │      │      │      │      │      │
  │      │      │      │      │      │
  ╰──────┴──────┴──────┴──────┴──────╯
  ```"
  event.respond(content: board)
end

bot.run