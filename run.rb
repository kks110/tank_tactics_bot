# frozen_string_literal: true

require 'discordrb'
require_relative './command/register_commands'
require 'pry'
require_relative './models/player'
require_relative './command/list'
require_relative './initialise'
require_relative './battle_log'

bot = Discordrb::Bot.new(token: ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil), intents: [:server_messages])
Command::RegisterCommands.run(bot: bot)

Command::LIST.each do |command|
  bot.application_command(command.name) do |event|
    puts "Executing command: #{command.name}"
    command.execute(event: event)
  end
end

bot.run
