# frozen_string_literal: true

require 'discordrb'
require_relative './command/register_commands'
require 'pry'
require_relative './models/player'
require_relative './models/game'
require_relative './models/heart'
require_relative './models/energy_cell'
require_relative './models/peace_vote'
require_relative './models/city'
require_relative './command/list'
require_relative './initialise'
require_relative './battle_log'
require_relative './config/game_data'

bot = Discordrb::Bot.new(token: ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil), intents: [:server_messages])
Command::RegisterCommands.run(bot: bot)

game_data = Config::GameData.new

Command::LIST.each do |command|
  bot.application_command(command.name) do |event|
    puts "Executing command: #{command.name}"
    command.execute(event: event, game_data: game_data)
  end
end

bot.run
