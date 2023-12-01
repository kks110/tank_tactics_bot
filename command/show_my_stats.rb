require_relative './base'
require_relative 'helpers/highest_and_lowest_stats'

module Command
  class ShowMyStats < Command::Base
    def name
      :show_my_stats
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
      "See your own stats"
    end

    def execute(context:)
      player = context.player
      event = context.event

      high_and_low = Command::Helpers::HighestAndLowestStats.generate_for_game_stats

      response = "```#{player.username}'s stats:\n"

      high_and_low.each do |command, high_low|
        next if command == 'id'
        next if command == 'player_id'

        parsed_name = command.gsub('_', ' ').capitalize
        stat = player.stats.send(command.to_sym)

        h_or_l = "\n"
        h_or_l = "(L)\n" if high_low[:low] == stat
        h_or_l = "(H)\n" if high_low[:high] == stat

        response << "#{parsed_name}:"
        (25-parsed_name.length).times do
          response << " "
        end

        response << "#{stat}"

        (6-stat.to_s.length).times do
          response << " "
        end

        response << h_or_l
      end

      response << "```"

      event.respond(content: response, ephemeral: true)
    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
