# frozen_string_literal: true

require 'discordrb'
require_relative './command/helpers/register_commands'
require 'pry'
require_relative './models/player'
require_relative './models/game'
require_relative './models/heart'
require_relative './models/energy_cell'
require_relative './models/peace_vote'
require_relative './models/city'
require_relative './models/stats'
require_relative './models/interested_player'
require_relative './command/helpers/list'
require_relative './initialise'
require_relative './battle_log'
require_relative './error_log'
require_relative './config/game_data'
require_relative './command/models/execute_params'
require_relative './config/initializers/inflections'

bot = Discordrb::Bot.new(token: ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil), intents: [:server_messages])
Command::Helpers::RegisterCommands.run(bot: bot)

game_data = Config::GameData.new

Command::Helpers::LIST.each do |command|
  bot.application_command(command.name) do |event|
    puts "#{event.user.username} executed command: #{command.name}"

    player = Player.find_by(discord_id: event.user.id)

    unless player
      event.respond(content: "You are not a player in this game!", ephemeral: true)
    else

    game = Game.find_by(server_id: event.server_id)

    if command.requires_game? && game.nil?
      event.respond(content: "The game hasn't started yet!", ephemeral: true)
    else
      context = Command::Models::ExecuteParams.new(
        event: event,
        game_data: game_data,
        bot: bot,
        game: game,
        player: player
      )

      command.execute(context: context)
    end
  end
end

bot.run
