require_relative './base'

module Command
  class IncreaseRange < Command::Base
    def name
      :increase_range
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      true
    end

    def requires_player_not_disabled?
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

      player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)
      player_global_stats.update(
        energy_spent: player_global_stats.energy_spent + range_increase_cost
      )

      if player.range > player_global_stats.highest_range
        player_global_stats.update(highest_range: player.range)
      end

      BattleLog.logger.info("#{player.username} increased their range to #{player.range}")

      event.channel.send_message 'Someone increased their range!'
      event.respond(content: "Range increased, you now have #{player.range} range", ephemeral: true)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
