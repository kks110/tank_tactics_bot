require_relative './base'
require_relative '../image_generation/grid'
require_relative '../image_generation/leaderboard'

module Command
  class ShowSpectatorBoard < Command::Base
    def name
      :show_spectator_board
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      false
    end

    def requires_player_not_disabled?
      false
    end

    def description
      "Show the game board for spectators"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data

      if player
        event.respond(content: "You cant 'spectate' if you are playing!", ephemeral: true)
        return
      end

      event.respond(content: "Sending you a dm", ephemeral: true)

      players = Player.all

      image_location = ImageGeneration::Grid.new.generate_spectator_game_board(
        players: players,
        game_data: game_data,
        server_id: game.server_id
      )

      stats = Stats.all
      leaderboard_image_location = ImageGeneration::Leaderboard.new.generate_leaderboard(
        game_data: game_data,
        stats: stats,
        column_headings: Stats.column_headings,
        column_names: Stats.column_names,
        high_and_low: Command::Helpers::HighestAndLowestStats.generate_for_game_stats
      )

      energy_message = "Player Energy: \n"

      players.each do |player|
        energy_message << "#{player.username}: #{player.energy}\n"
      end

      event.user.send_file File.new(image_location)
      event.user.send_file File.new(leaderboard_image_location)
      event.user.pm energy_message

    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
