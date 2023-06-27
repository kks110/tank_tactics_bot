require_relative './base'

module Commands
  class IncreaseHp < Commands::Base
    def name
      :increase_hp
    end

    def description
      "Increase HP by 1 for 3 energy"
    end

    def execute(event:)
      user = event.interaction.user
      player = Player.find_by(discord_id: user.id)

      unless player.energy > 2
        event.respond(content: "Not enough energy!")
        return
      end

      player.update(energy: player.energy - 3, hp: player.hp + 1)

      event.respond(content: "Health increased, you now have #{player.hp}HP")

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end