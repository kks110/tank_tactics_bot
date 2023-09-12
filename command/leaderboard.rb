require_relative './base'
require_relative '../image_generation/leaderboard'
require_relative 'helpers/highest_and_lowest_stats'

module Command
  class Leaderboard < Command::Base
    def name
      :leaderboard
    end

    def requires_game?
      true
    end

    def description
      "See who's on top (disabled in fog games)"
    end

    def execute(context:)
      game_data = context.game_data
      game = context.game
      event = context.event

      stats = Stats.all

      image_location = ImageGeneration::Leaderboard.new.generate_leaderboard(
        game_data: game_data,
        stats:stats,
        column_headings: Stats.column_headings,
        column_names: Stats.column_names,
        high_and_low: Command::Helpers::HighestAndLowestStats.generate
      )

      event.respond(content: "Generating leaderboard...", ephemeral: true)
      event.channel.send_file File.new(image_location)
      event.delete_response
    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
