# frozen_string_literal: true

require 'discordrb'
require './register_commands'
require 'pry'
require './models/player'
require './commands/list'
require './initialise'

bot = Discordrb::Bot.new(token: ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil), intents: [:server_messages])
RegisterCommands.run(bot: bot)

Commands::LIST.each do |command|
  bot.application_command(command.name) do |event|
    command.execute(event: event)
  end
end

bot.run

# TODO: Workout how to send messages to 1 person
# TODO: See if there is a auto generated help
# TODO: Show range
# TODO: Reset game
# TODO: Use config for board sizes
# TODO: Use config for energy costs
