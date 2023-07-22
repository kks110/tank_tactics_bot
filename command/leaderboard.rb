require_relative './base'
require_relative './helpers/generate_grid'
require_relative './models/options'

module Command
  class Leaderboard < Command::Base
    def name
      :leaderboard
    end

    def description
      "See who's on top"
    end

    def execute(event:, game_data:, bot:)
      game = Game.find_by(server_id: event.server_id)

      if game.fog_of_war
        event.respond(content: 'Leaderboard is disabled in fog of war games')
        return
      end

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
        "K: #{player.kills} / D: #{player.deaths}\n"
      when 'city_captures'
        "City Captureas: #{player.city_captures}\n"
      end
    end

    def options
      [
        Command::Models::Options.new(
          type: 'string',
          name: 'rank_by',
          description: 'Pick the order that you want to rank people by',
          choices: { kills: 'kills', city_captures: 'city_captures' }
        )
      ]
    end
  end
end