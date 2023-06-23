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

bot.application_command(:draw_board) do |event|
  # board = "```
  # ╭──────┬──────┬──────┬──────┬──────╮
  # │1  3HP│      │      │      │      │
  # │ Adam │      │      │      │      │
  # ├──────┼──────┼──────┼──────┼──────┤
  # │      │      │      │      │      │
  # │      │      │      │      │      │
  # ├──────┼──────┼──────┼──────┼──────┤
  # │      │      │      │      │      │
  # │      │      │      │      │      │
  # ├──────┼──────┼──────┼──────┼──────┤
  # │      │      │      │      │      │
  # │      │      │      │      │      │
  # ├──────┼──────┼──────┼──────┼──────┤
  # │      │      │      │      │      │
  # │      │      │      │      │      │
  # ╰──────┴──────┴──────┴──────┴──────╯
  # ```"
  # event.respond(content: board)
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