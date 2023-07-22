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
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end