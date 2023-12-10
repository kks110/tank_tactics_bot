require_relative './base'
require_relative 'helpers/highest_and_lowest_stats'

module Command
  class ShowAllTimeStats < Command::Base
    def name
      :show_all_time_stats
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
      "See a players all time stats, default is yourself is no username given"
    end

    def execute(context:)
      event = context.event

      high_and_low = Command::Helpers::HighestAndLowestStats.generate_for_global_stats

      players_username = event.options['username']
      players_username = event.user.username if players_username.nil?

      stats = GlobalStats.find_by(username: players_username.downcase)

      if stats.nil?
        event.respond(content: "Cannot find stats for a player with the username #{players_username}", ephemeral: true)
      end

      response = "```#{players_username}'s stats:\n"

      high_and_low.each do |command, high_low|
        next if command == 'id'
        next if command == 'username'
        next if command == 'player_discord_id'

        parsed_name = command.gsub('_', ' ').capitalize
        stat = stats.send(command.to_sym)

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

      event.respond(content: response)
    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
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
