require_relative './base'

module Command
  class SwapHpForEnergy < Command::Base
    def name
      :swap_hp_for_energy
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
      'Swap 1 HP for 10 Energy'
    end

    def execute(context:)
      event = context.event
      player = context.player
      game_data = context.game_data

      unless player.hp > game_data.swap_hp_for_energy_cost
        event.respond(content: "You can't do this, it will kill you!", ephemeral: true)
        return
      end

      player.update(energy: player.energy + game_data.energy_from_hp, hp: player.hp - game_data.swap_hp_for_energy_cost)

      event.respond(content: "Energy increased, you now have #{player.energy}", ephemeral: true)

      event.channel.send_message "Someone traded HP for energy!"

      if player.energy > player.stats.highest_energy
        player.stats.update(highest_energy: player.energy)
      end

      player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)

      if player.energy > player_global_stats.highest_energy
        player_global_stats.update(highest_energy: player.energy)
      end

      Logging::BattleReport.logger.info(
        Logging::BattleReportBuilder.build(
          command_name: name,
          player_name: player.username
        )
      )
    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
