require_relative './base'
require_relative './helpers/player_list'

module Command
  class ShowPlayers < Command::Base
    def name
      :show_players
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
      "Show's the players in the game"
    end

    def execute(context:)
      event = context.event
      game = context.game

      if game.nil?
        event.respond(content: "A game hasn't been created yet", ephemeral: true)
        return
      end

      event.respond(content: PlayerList.build, ephemeral: true)
    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end