require_relative './base'

module Command
  class ShowEnergy < Command::Base
    def name
      :show_energy
    end

    def description
      "Show how much energy you have"
    end

    def execute(context:)
      event = context.event
      player = context.player

      event.respond(content: "You have #{player.energy} energy", ephemeral: true)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end