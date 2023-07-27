require_relative './base'

module Command
  class IncreaseRange < Command::Base
    def name
      :increase_range
    end

    def description
      "Increase range by 1 for 30 energy"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data

      unless player.energy >= game_data.increase_range_cost
        event.respond(content: "Not enough energy!", ephemeral: true)
        return
      end

      player.update(energy: player.energy - game_data.increase_range_cost, range: player.range + 1)

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
