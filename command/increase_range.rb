require_relative './base'

module Command
  class IncreaseRange < Command::Base
    def name
      :increase_range
    end

    def description
      "Increase range by 1 for 30 energy"
    end

    def execute(event:, game_data:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.energy >= game_data.increase_range_cost
        event.respond(content: "Not enough energy!")
        return
      end

      player.update(energy: player.energy - game_data.increase_range_cost, range: player.range + 1)

      BattleLog.logger.info("#{player.username} increased their range to #{player.range}")
      event.respond(content: "Range increased, you now have #{player.range} range")

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end