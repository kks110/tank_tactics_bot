require_relative './base'

module Commands
  class ShowEnergy < Commands::Base
    def name
      :show_energy
    end

    def description
      "Show how much energy you have"
    end

    def execute(event:)
      user = event.interaction.user
      player = Player.find_by(discord_id: user.id)

      event.respond(content: "You have #{player.energy} energy", ephemeral: true)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end