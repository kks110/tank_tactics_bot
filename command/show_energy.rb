require_relative './base'

module Command
  class ShowEnergy < Command::Base
    def name
      :show_energy
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
      "Show how much energy you have"
    end

    def execute(context:)
      event = context.event
      player = context.player

      event.respond(content: "You have #{player.energy} energy", ephemeral: true)

    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end