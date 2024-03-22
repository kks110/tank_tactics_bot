# frozen_string_literal: true

require 'ostruct'
require 'discordrb'
require_relative './command/helpers/register_commands'
require 'pry'
require_relative './models/player'
require_relative './models/game'
require_relative './models/energy_cell'
require_relative './models/peace_vote'
require_relative './models/city'
require_relative './models/stats'
require_relative './models/interested_player'
require_relative './models/shot'
require_relative './models/global_stats'
require_relative './command/helpers/list'
require_relative './initialise'
require_relative './logging/error_log'
require_relative './logging/battle_report'
require_relative './logging/battle_report_builder'
require_relative './config/game_data'
require_relative './command/models/execute_params'
require_relative './config/initializers/inflections'
require_relative './command/helpers/time'

bot = Discordrb::Bot.new(token: ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil), intents: [:server_messages])
Command::Helpers::RegisterCommands.run(bot: bot)

game_data = Config::GameData.new

Command::Helpers::LIST.each do |command|
  bot.application_command(command.name) do |event|
    puts "#{event.user.username} executed command: #{command.name}"

    game = Game.find_by(server_id: event.server_id)

    if command.requires_game? && (game.nil? || !game.started) && command.name != :start_game
      event.respond(content: "The game hasn't started yet!", ephemeral: true)
    end

    player = Player.find_by(discord_id: event.user.id)

    if command.name == :start_game && game.nil?
      event.respond(content: "There is not game to start!", ephemeral: true)
    elsif player.nil? && command.requires_game? && command.name != :show_spectator_board
      event.respond(content: "You are not a player in this game!", ephemeral: true)
    elsif command.requires_player_alive? && !player.alive?
      event.respond(content: "You're dead, you cant do that!", ephemeral: true)
    elsif command.requires_player_not_disabled? && player.disabled?
      seconds_until_reset = player.disabled_until - Time.now
      event.respond(content: "You are disabled and will able to move in #{Command::Helpers::Time.seconds_to_hms(seconds_until_reset)}", ephemeral: true)
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

    commands_that_could_result_in_one_player_alive = [:ramming_speed, :shoot]

    if commands_that_could_result_in_one_player_alive.include?(command.name) && Player.all.select(&:alive?).count <= 1
      Command::Helpers::CleanUp.run(event: event, game_data: game_data, game: game)
    end
  end
end

bot.run
