# frozen_string_literal: true

require 'discordrb'
require './command/register_commands'
require 'pry'
require './models/player'
require './command/list'
require './initialise'
require './battle_log'

bot = Discordrb::Bot.new(token: ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil), intents: [:server_messages])
Command::RegisterCommands.run(bot: bot)

Command::LIST.each do |command|
  bot.application_command(command.name) do |event|
    puts "Executing command: #{command.name}"
    command.execute(event: event)
  end
end

bot.run

# Must haves:
# TODO: Create a game instructions
# TODO: Show tank range

# Nice to haves
# TODO: Have some kind of game state. Started, winner, that kind of thing
# TODO: Have leader board, ranking by hp, kills, range
# TODO: Come up with some kind of standard notation, and write something that can play out the the game a step at a time
# TODO: Shoot / give to player names rather than coordinates
# TODO: Reset game
# TODO: Use config for board sizes (or make optional at game start?)
# TODO: Use config for energy costs (or make optional at game start?)
# TODO: Run rubocop
# TODO: Tests?
# TODO: Option to show board just to your self?
