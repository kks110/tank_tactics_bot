require_relative './base'

module Command
  class IncreaseRange < Command::Base
    def name
      :increase_range
    end

    def requires_game?
      true
    end

    def description
      "Increase range by 1 for 30 energy + 10 for each level"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data

      range_increase_cost = game_data.increase_range_base_cost + ((player.range - game_data.starting_range) * game_data.increase_range_per_level_cost )

      unless player.energy >= range_increase_cost
        event.respond(content: "Not enough energy!", ephemeral: true)
        return
      end

      player.update(energy: player.energy - range_increase_cost, range: player.range + 1)
      player.stats.update(
        highest_range: player.range,
        energy_spent: player.stats.energy_spent + range_increase_cost
      )

      BattleLog.logger.info("#{player.username} increased their range to #{player.range}")

      if game.fog_of_war
        event.channel.send_message 'Someone increased their range!'
        event.respond(content: "Range increased, you now have #{player.range} range", ephemeral: true)
      else
        event.respond(content: "Range increased, you now have #{player.range} range")
      end

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
