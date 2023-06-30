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

# TODO: Make board 'round'
# TODO: Show tank range
# TODO: Look in to better random distributions
# TODO: Shoot / give to player names rather than coordinates
# TODO: Have some kind of game state. Started, winner, that kind of thing
# TODO: Run rubocop
# TODO: Reset game
# TODO: Use config for board sizes (or make optional at game start?)
# TODO: Use config for energy costs (or make optional at game start?)
# TODO: Come up with some kind of standard notation, and write something that can play out the the game a step at a time
# TODO: Tests?

# Updates in this patch:
# Have leader board, ranking by hp, kills, range
# Option to show board just to your self?
# Make give energy ephemeral
