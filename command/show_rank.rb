require_relative './base'
require_relative 'helpers/highest_and_lowest_stats'
require_relative '../image_generation/rank_card'

module Command
  class ShowRank < Command::Base
    def name
      :show_rank
    end

    def requires_game?
      false
    end

    def requires_player_alive?
      false
    end

    def requires_player_not_disabled?
      false
    end

    def description
      "See a players rank, default is yourself is no username given"
    end

    def execute(context:)
      event = context.event
      game_data = context.game_data

      high_and_low = Command::Helpers::HighestAndLowestStats.generate_for_global_stats

      players_username = event.options['username']
      players_username = event.user.username if players_username.nil?

      stats = GlobalStats.find_by(username: players_username)

      if stats.nil?
        event.respond(content: "Cannot find stats for a player with the username #{players_username}", ephemeral: true)
      end

      card_template = ImageGeneration::RankCard.new.generate_rank_card(
        game_data: game_data,
        stats: stats,
        high_and_low: high_and_low
      )

      event.respond(content: "Generating rank card...")
      event.channel.send_file File.new(card_template)
    # rescue => e
    #   ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end

    def options
      [
        Command::Models::Options.new(
          type: 'string',
          name: 'username',
          description: 'The username of the player you want the stats of (Default is yourself)',
          required: false,
          )
      ]
    end
  end
end
