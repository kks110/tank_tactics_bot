module Command
  module Helpers
    class CleanUp
      def self.run(event:, game_data:, game:, peace_vote: false)
        players = Player.all
        winners = players.select(&:alive?)

        response = ""

        response << "The vote for peace has been successful!\n" if peace_vote

        response << "The game has ended!\nThe winner's are:"

        winners.each do |winner|
          response << " <@#{winner.discord_id}>"

          winner_global_stats = GlobalStats.find_by(player_discord_id: winner.discord_id)
          winner_global_stats.update(games_won: winner_global_stats.games_won + 1)
        end

        response << "\n"

        event.channel.send_message response

        stats = Stats.all

        leaderboard_image_location = ImageGeneration::Leaderboard.new.generate_leaderboard(
          game_data: game_data,
          stats: stats,
          column_headings: Stats.column_headings,
          column_names: Stats.column_names,
          high_and_low: Command::Helpers::HighestAndLowestStats.generate_for_game_stats
        )
        event.channel.send_file File.new(leaderboard_image_location)

        game_board_image_location = ImageGeneration::Grid.new.generate_spectator_game_board(
          players: players,
          game_data: game_data,
          server_id: game.server_id
        )

        event.channel.send_file File.new(game_board_image_location)

        Logging::BattleReport.logger.info(
          Logging::BattleReportBuilder.build(
            command_name: :game_end,
            player_name: 'Bot'
          )
        )
        battle_report_location = Logging::BattleReport.log_path
        event.channel.send_file File.new(battle_report_location)

        PeaceVote.delete_all

        stats.each(&:destroy)

        Shot.delete_all

        players.each do |player|
          player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)
          player_global_stats.update(games_played: player_global_stats.games_played + 1)
          player.destroy
        end

        game.destroy

        EnergyCell.delete_all

        City.delete_all
      end
    end
  end
end
