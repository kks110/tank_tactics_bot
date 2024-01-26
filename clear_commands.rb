# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'

discord_token = ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil)
server_id = ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)

bot = Discordrb::Bot.new(token: discord_token, intents: [:server_messages])

commands = bot.get_application_commands(server_id: server_id)

commands.each do |cmd|
  puts "Removing #{cmd.name}"
  bot.delete_application_command(cmd.id, server_id: server_id)
end
