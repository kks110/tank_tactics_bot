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


# TODO: automate energy distribution 
# TODO: Show tank range
# TODO: Look in to better random distributions
# TODO: Have some kind of game state. Started, winner, that kind of thing and add a check after each command to see if there is a winner
# TODO: Run rubocop
# TODO: Reset game
# TODO: Use config for board sizes (or make optional at game start?)
# TODO: Use config for energy costs (or make optional at game start?)
# TODO: Come up with some kind of standard notation, and write something that can play out the the game a step at a time
# TODO: Tests?
# TODO: Look at image generation for the board

# For next game
# TODO: Have random heart spawn when daily energy is given
# TODO: Make board 'round'

# Updates in this patch:
# Mentions on daily update and on being shot
