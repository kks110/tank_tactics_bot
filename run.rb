# frozen_string_literal: true

require 'discordrb'
require './command/register_commands'
require 'pry'
require './models/player'
require './command/list'
require './initialise'

bot = Discordrb::Bot.new(token: ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil), intents: [:server_messages])
Command::RegisterCommands.run(bot: bot)

Command::LIST.each do |command|
  bot.application_command(command.name) do |event|
    command.execute(event: event)
  end
end

bot.run

# Must haves:
# TODO: Create a help
# TODO: Create a game instructions
# TODO: Show tank range
# TODO: Reset game
# TODO: Create a game log

# Nice to haves
# TODO: Shoot / give to player names rather than coordinates
# TODO: Use config for board sizes
# TODO: Use config for energy costs
# TODO: Run rubocop
# TODO: Tests?
#