require_relative './base'
require_relative '../image_generation/leaderboard'

module Command
  class Leaderboard < Command::Base
    def name
      :leaderboard
    end

    def requires_game?
      true
    end

    def description
      "See who's on top"
    end

    def execute(context:)
      game_data = context.game_data
      game = context.game
      event = context.event

      if game.fog_of_war
        event.respond(content: 'Leaderboard is disabled in fog of war games')
        return
      end

      stats = Stats.all

      highest_and_lowest = {}
      Stats.column_names.each do |column|
        highest_and_lowest[column] = {
          low: 0,
          high: 0
        }
      end

      stats.each do |stat|
        highest_and_lowest.each do |k,_|
          player_stat = stat.send(k.to_sym)
          highest_and_lowest[k][:low] = player_stat if highest_and_lowest[k][:low] > player_stat
          highest_and_lowest[k][:high] = player_stat if highest_and_lowest[k][:high] < player_stat
          end
        end
      end

      image_location = ImageGeneration::Leaderboard.new.generate_leaderboard(
        game_data: game_data,
        stats:stats,
        column_headings: Stats.column_headings,
        column_names: Stats.column_names,
        high_and_low: highest_and_lowest
      )

      event.respond(content: "Generating the grid...", ephemeral: true)
      event.channel.send_file File.new(image_location)
      event.delete_response
    # rescue => e
    #   ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
