require_relative './base'
require_relative './helpers/generate_grid'
require_relative './options'

module Command
  class Leaderboard < Command::Base
    def name
      :leaderboard
    end

    def description
      "See whos on top"
    end

    def execute(event:, game_data:)
      rank_by = event.options['rank_by']
      rank_by = 'kills' if rank_by.nil?

      players = Player.order({rank_by => :desc})

      response = "Players ordered by #{rank_by}\n"
      players.each_with_index do |player, counter|
        response << "#{counter + 1}) #{player.username} #{message_order_logic(player, rank_by)}"
      end

      event.respond(content: response)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end

    def message_order_logic(player, rank_by)
      case rank_by
      when 'kills'
        "| K: #{player.kills} / D: #{player.deaths}  |  HP: #{player.hp}  |  RNG: #{player.range}\n"
      when 'deaths'
        "D:#{player.deaths} / K: #{player.kills}  |  HP :#{player.hp}  |  RNG: #{player.range}\n"
      when 'hp'
        "HP:#{player.hp}  |  K: #{player.kills} / D: #{player.deaths}  |  RNG: #{player.range}\n"
      when 'range'
        "RNG: #{player.range}  |  K: #{player.kills} / D: #{player.deaths}  |  HP: #{player.hp}\n"
      end
    end

    def options
      [
        Command::Options.new(
          type: 'string',
          name: 'rank_by',
          description: 'Pick the order that you want to rank people by',
          choices: { hp: 'hp', range: 'range', kills: 'kills', deaths: 'deaths' }
        )
      ]
    end
  end
end