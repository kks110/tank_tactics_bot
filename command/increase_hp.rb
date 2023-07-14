require_relative './base'

module Command
  class IncreaseHp < Command::Base
    def name
      :increase_hp
    end

    def description
      "Increase HP by 1 for 30 energy"
    end

    def execute(event:, game_data:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.energy >= game_data.increase_hp_cost
        event.respond(content: "Not enough energy!")
        return
      end

      player.update(energy: player.energy - game_data.increase_hp_cost, hp: player.hp + 1)

      BattleLog.logger.info("#{player.username} Increased their HP to #{player.hp}")
      event.respond(content: "Health increased, you now have #{player.hp}HP")

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end